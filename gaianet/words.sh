#!/bin/bash

# Створення директорії, якщо вона ще не існує
mkdir -p /root/words

# Завантаження файлу (якщо ще не завантажений)
curl -o /root/words/trivia_questions.txt "https://gist.githubusercontent.com/khamer/66102c745a9a75de997c038e3166a95d/raw/9402b9abdd52250068598f562d7492ad4efad88c/trivia%2520questions.txt"

# Створення або очищення файлу для запитань
> /root/words/questions_only.txt

# Читання файлу рядок за рядком
while IFS= read -r line; do
  # Виділення лише питання, видаляючи відповідь та зайві символи
  question=$(echo "$line" | sed -E 's/\["(.*?)", ".*"\]/\1/')

  # Запис у новий файл у форматі echo -e "\""
  if [[ ! -z "$question" ]]; then
    echo -e "\"$question\"" >> /root/words/questions_only.txt
  fi
done < /root/words/trivia_questions.txt

echo "✅ Обробка завершена! Запитання збережено у файлі /root/words/questions_only.txt."
