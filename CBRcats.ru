<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Вход и Регистрация</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('https://4kwallpapers.com/images/walls/thumbs_3t/9659.jpg');
            background-repeat: no-repeat;
            background-position: center center;
            background-attachment: fixed;
            background-size: cover; 
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #ffffff;
            overflow-x: hidden;
        }

        .main-container {
            background: rgba(15, 15, 20, 0.75);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-radius: 12px;
            padding: 40px;
            width: 90%;
            max-width: 820px;
            display: flex;
            flex-wrap: wrap; 
            gap: 45px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.9);
            border: 1px solid rgba(255,255,255,0.08);
        }

        .info-section {
            flex: 1;
            min-width: 250px;
        }

        .info-section h2 {
            font-size: 16px;
            text-transform: uppercase;
            margin-bottom: 15px;
            letter-spacing: 1.5px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 10px;
        }

        .description {
            color: #d1d1d1;
            font-size: 14px;
            margin-bottom: 40px;
            line-height: 1.5;
        }

        .links-list {
            list-style: none;
            padding: 0;
        }

        .links-list li {
            margin-bottom: 12px;
            display: flex;
            align-items: center;
        }

        .links-list a {
            color: #8fa3ff;
            text-decoration: none;
            font-size: 14px;
        }

        .auth-section {
            flex: 1.2;
            min-width: 280px;
        }

        .auth-section h2 {
            font-size: 18px;
            margin-top: 0;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .label-text {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            font-size: 14px;
        }

        input {
            width: 100%;
            padding: 12px;
            background: rgba(40, 40, 50, 0.6);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 5px;
            color: #fff;
            box-sizing: border-box;
            outline: none;
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            color: white;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            font-size: 14px;
            transition: opacity 0.2s;
        }

        .btn:hover { opacity: 0.9; }
        .btn-blue { background-color: #4a76a8; }
        .btn-green { background-color: #5cb85c; margin-top: 15px; }

        .captcha {
            display: flex;
            align-items: center;
            margin: 18px 0;
            font-size: 14px;
        }

        .captcha input { width: auto; margin-right: 12px; }

        hr {
            border: 0;
            border-top: 1px solid rgba(255,255,255,0.1);
            margin: 25px 0;
        }
    </style>
</head>
<body>

<div class="main-container">
    <div class="info-section">
        <h2>ОБ ИГРЕ</h2>
        <div class="description">
            Здравствуйте, это игровая онлайн по КВ(котам воителям)! Здесь намного больше функций чем вы думаете, но надеюсь вам сама игра, очень понравится. Как разработчик, я буду очень рад если появятся новые люди!
        </div>

        <h2>СВЯЗИ</h2>
        <ul class="links-list">
            <li>
                <span style="margin-right: 10px;">🐾</span>
                <a href="https://vk.com/CBRcats" target="_blank">Сообщество ВК</a>
            </li>
            <li>
                <span style="margin-right: 10px;">👤</span>
                <a href="https://vk.com/inksans" target="_blank">Мой ВК</a>
            </li>
        </ul>
    </div>

    <div class="auth-section">
        <h2>ВХОД | РЕГИСТРАЦИЯ</h2>
        
        <div class="form-group">
            <span class="label-text">Вход</span>
            <input type="text" id="loginEmail" placeholder="Почта">
        </div>
        <div class="form-group">
            <input type="password" id="loginPassword" placeholder="Пароль">
        </div>
        <button class="btn btn-blue" onclick="handleLogin()">OK</button>

        <hr>

        <div class="form-group">
            <span class="label-text">Регистрация</span>
            <input type="text" id="regEmail" placeholder="Почта">
        </div>
        <div class="form-group">
            <input type="password" id="regPassword" placeholder="Пароль">
        </div>

        <div class="captcha">
            <input type="checkbox" id="robot" checked>
            <label for="robot">Я не робот 🤖</label>
        </div>

        <button class="btn btn-green" onclick="handleRegister()">СОЗДАТЬ АККАУНТ</button>
    </div>
</div>

<script>
    // Пути к страницам согласно твоей структуре папок
    const registrationPage = 'pages/registration.html';
    const profilePage = 'pages/my_cat.html';

    function handleRegister() {
        const email = document.getElementById('regEmail').value;
        const pass = document.getElementById('regPassword').value;

        if(email && pass) {
            localStorage.setItem('userEmail', email);
            localStorage.setItem('userPass', pass);
            alert('Регистрация успешна! Теперь создайте своего кота.');
            // Переход на страницу создания персонажа
            window.location.href = registrationPage;
        } else {
            alert('Заполните все поля регистрации!');
        }
    }

    function handleLogin() {
        const email = document.getElementById('loginEmail').value;
        const pass = document.getElementById('loginPassword').value;
        
        const savedEmail = localStorage.getItem('userEmail');
        const savedPass = localStorage.getItem('userPass');

        if(email === savedEmail && pass === savedPass && email !== null) {
            // Сохраняем текущую почту, чтобы другие страницы знали, чей профиль грузить
            localStorage.setItem('userEmail', email);
            
            // Проверяем, есть ли уже созданный кот для этой почты
            const catSave = localStorage.getItem('save_' + email);
            
            if(catSave) {
                // Если кот есть — идем в профиль "Мой котик"
                window.location.href = profilePage;
            } else {
                // Если кота нет — идем создавать
                window.location.href = registrationPage;
            }
        } else {
            alert('Неверные данные или аккаунт не существует!');
        }
    }
</script>

</body>
</html>
