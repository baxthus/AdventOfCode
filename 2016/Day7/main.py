import re
import sys

def contains_abba(s: str) -> bool:
    for i in range(len(s) - 3):
        if s[i] != s[i + 1] and s[i] == s[i + 3] and s[i + 1] == s[i + 2]:
            return True
    return False

def collect_aba(s: str) -> set[str]:
    abas: set[str] = set()
    for i in range(len(s) - 2):
        if s[i] != s[i + 1] and s[i] == s[i + 2]:
            abas.add(s[i:i + 3])
    return abas

def contains_bab(s: str, abas: set[str]) -> bool:
    for i in range(len(s) - 2):
        if s[i] != s[i+1] and s[i] == s[i+2]:
            bab_to_aba = s[i+1] + s[i] + s[i+1]
            if bab_to_aba in abas:
                return True
    return False

def split_segments(ip: str) -> tuple[list[str], list[str]]:
    supernet: list[str] = []
    hypernet: list[str] = []

    hypernet_segments = re.findall(r'\[([a-z]+)\]', ip)
    hypernet.extend(hypernet_segments)

    placeholder = '@@@'
    modified_ip = re.sub(r'\[([a-z]+)\]', placeholder, ip)

    supernet_parts = modified_ip.split(placeholder)
    supernet.extend(filter(None, supernet_parts))

    return supernet, hypernet

if __name__ == '__main__':
    ips = [line.strip() for line in sys.stdin if line.strip()]

    tls_count = 0
    ssl_count = 0

    for ip in ips:
        supernet_segments, hypernet_segments = split_segments(ip)

        has_abba_outside = False
        for segment in supernet_segments:
            if contains_abba(segment):
                has_abba_outside = True
                break

        has_abba_inside = False
        for segment in hypernet_segments:
            if contains_abba(segment):
                has_abba_inside = True
                break

        if has_abba_outside and not has_abba_inside:
            tls_count += 1

        all_abas: set[str] = set()
        for segment in supernet_segments:
            all_abas.update(collect_aba(segment))

        supports_ssl = False
        if all_abas:
            for segment in hypernet_segments:
                if contains_bab(segment, all_abas):
                    supports_ssl = True
                    break

        if supports_ssl:
            ssl_count += 1

    print(f'Part 1: {tls_count}')
    print(f'Part 2: {ssl_count}')
