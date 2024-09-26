# Указывает базовый образ для создания контейнера. 
# В данном случае используется образ Python версии 3.10, 
# основанный на минимальной урезанной версии операционной системы (slim).
FROM python:3.10-slim

# Открывает порт 8000 в контейнере. Это необходимо для того,  
# чтобы внешние приложения могли обращаться к вашему Django-приложению через 
# этот порт.
EXPOSE 8000 

# Устанавливает переменную окружения для Python, 
# чтобы гарантировать, что вывод Python будет отправляться прямо 
# в терминал без буферизации. 
# Это полезно для лучшего контроля над выводом логов.
ENV PYTHONUNBUFFERED=1

ENV PYTHONDONTWRITEBYTECODE=1

# Копируем все requirements.txt 
COPY requirements.txt .

# Устанавливает зависимости, перечисленные в файле requirements.txt, 
# используя инструмент управления пакетами pip. 
RUN python -m pip install -r requirements.txt

# Устанавливает рабочую директорию внутри контейнера. 
# Все последующие команды будут выполняться в этой директории.
WORKDIR /app

# Копирует все файлы проекта из локальной директории 
# внешнего проекта внутрь контейнера 
# в директорию /app/.
COPY . /app

# Создает пользователя без прав root с явным UID и добавляет 
# разрешение на доступ к папке /app
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# Запускаем сервер Django при старте контейнера
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
