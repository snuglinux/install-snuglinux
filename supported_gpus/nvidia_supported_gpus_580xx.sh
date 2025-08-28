#!/bin/bash

url="https://download.nvidia.com/XFree86/Linux-x86_64/580.76.05/README/supportedchips.html"
output_file="nvidia-580xx"

curl -s "$url" \
| sed '/legacy_470\.xx/,$d' \
| awk '
/<tr id/ {gpu=""; pci=""}
/<td>/ {
    # видаляємо всі HTML-теги з поточного рядка, залишаємо тільки текст
    line = $0
    gsub(/<[^>]*>/,"",line)
    gsub(/^[ \t]+|[ \t]+$/,"",line)
    if (gpu == "") gpu = line
    else if (pci == "") pci = line
}
# Умова — без /.../ !
gpu != "" && pci != "" {
    # використовуємо toupper (скористайся gawk, якщо доступний)
    printf "%s | %s\n", gpu, toupper(pci)
    gpu=""; pci=""
}
' > "$output_file"

echo "Дані збережено у $output_file"
