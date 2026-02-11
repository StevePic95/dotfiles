#!/usr/bin/env python3

from pathlib import Path
from sys import exit as exit_with_code
from re import findall
from rich import print as rprint

CUSTOM_ALIAS_FP = Path.home() / "dotfiles" / "zsh" / ".zsh_custom_aliases"
FILE_PATTERN = r'###\s*#\s*TITLE:\s*(.*)\n\s*#\s*DESCRIPTION:\s*(.*)\n\s*#\s*EXAMPLES:\s*(.*)\n\s*alias\s*(\w*)=(.*)\n###'


def main():
    file_string = get_file_string(CUSTOM_ALIAS_FP)
    if file_string is None:
        print(f"Could not find alias file at {str(CUSTOM_ALIAS_FP)}")
        exit_with_code(1)

    parsed_aliases = parse_string(file_string)
    rprint(format(parsed_aliases))
    exit_with_code(0)


def get_file_string(fp: Path) -> str | None:
    if fp.exists() and fp.is_file():
        with open(fp, 'r') as file:
            return file.read()
    return None

def parse_string(fs: str) -> list:
    alias_tuples = findall(FILE_PATTERN, fs)
    result = []
    for title, description, examples, alias, real_expression in alias_tuples:
        result.append({
            "alias": alias,
            "title": title,
            "description": description,
            "examples": [tuple(e.split("::")) for e in examples.split("||")],
            "real_expression": real_expression
        })
    return result

def format(alias_list: list[dict]) -> str:
    result = ["\n" + "-" * 40 + "\n"]
    for a in alias_list:
        formatted_str = f"[blue]Alias:[/blue] {a['alias']}\n"
        formatted_str += f"[green]Title:[/green] {a['title']}\n"
        formatted_str += f"[green]Description:[/green] {a['description']}\n"
        formatted_str += f"[green]Examples:[/green]\n"
        
        for example in a['examples']:
            formatted_str += f"  [cyan]-[/cyan] {example[0]}: [cyan]{example[1]}[/cyan]\n"
        
        formatted_str += f"[green]Real Expression:[/green] {a['real_expression']}\n"
        formatted_str += "-" * 40 + "\n"
        
        result.append(formatted_str)
    
    return "".join(result)


if __name__ == "__main__":
    main()
