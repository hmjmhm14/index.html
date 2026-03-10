<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CBRcats: WORLD ENGINE</title>
    <style>
        :root {
            --bg-dark: #121717;
            --panel-bg: #1a1f1f;
            --accent-purple: #9c27b0;
            --accent-blue: #3498db;
            --text-gray: #b0b0b0;
            --border-color: #2c3434;
        }

        body, html {
            margin: 0; padding: 0;
            height: 100%; width: 100%;
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--bg-dark);
            color: white;
            overflow: hidden;
        }

        /* --- ЭКРАН ВХОДА И РЕГИСТРАЦИИ --- */
        #auth-screen {
            position: fixed; inset: 0;
            background: #0f1212;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            z-index: 1000;
        }

        /* Переключатель Вход/Регистрация */
        .auth-tabs {
            margin-bottom: 20px;
            display: flex;
            gap: 20px;
            font-size: 24px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .auth-tab {
            cursor: pointer;
            color: #444;
            transition: 0.3s;
        }

        .auth-tab.active {
            color: #ff4444; /* Цвет как на твоем наброске */
            text-shadow: 0 0 10px rgba(255, 68, 68, 0.5);
        }

        .auth-container {
            background: var(--panel-bg);
            padding: 30px;
            border-radius: 12px;
            width: 350px;
            border: 1px solid var(--border-color);
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .auth-container input {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            background: #0b0e0e;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            color: white;
            box-sizing: border-box;
        }

        .auth-btn {
            width: 100%;
            padding: 12px;
            background: var(--accent-blue);
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
            font-size: 16px;
        }

        /* --- ОСТАЛЬНОЙ ИНТЕРФЕЙС --- */
        #main-ui { display: none; height: 100vh; width: 100vw; }
        #sidebar { width: 70px; background: #0b0e0e; display: flex; flex-direction: column; align-items: center; padding-top: 20px; border-right: 1px solid var(--border-color); gap: 15px; }
        .nav-btn { width: 45px; height: 45px; background: #1e2424; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: 0.2s; border: none; font-size: 20px; }
        .nav-btn:hover { background: var(--accent-blue); }
        .nav-btn.active { border-left: 3px solid var(--accent-blue); background: #252d2d; }
        .nav-btn.admin-only { background: var(--accent-purple); display: none; }
        #content-area { flex: 1; position: relative; display: flex; flex-direction: column; }
        #top-bar { height: 50px; background: var(--panel-bg); display: flex; align-items: center; padding: 0 20px; justify-content: space-between; border-bottom: 1px solid var(--border-color); }
        .window { display: none; padding: 20px; height: calc(100% - 50px); overflow-y: auto; }
        .window.active { display: block; }
        #game-window { padding: 0; background-image: radial-gradient(circle, #1a2323 1px, transparent 1px); background-size: 30px 30px; position: relative; }
        #player { position: absolute; transition: 0.3s ease-out; text-align: center; z-index: 10; }
        .player-avatar { width: 85px; height: auto; filter: drop-shadow(0 0 8px rgba(0,0,0,0.4)); transition: transform 0.2s; }
        #right-panel { position: absolute; right: 20px; top: 20px; bottom: 20px; width: 350px; background: rgba(26, 31, 31, 0.9); border: 1px solid var(--border-color); border-radius: 12px; padding: 15px; display: flex; flex-direction: column; }
        #notepad { flex: 1; background: #0b0e0e; color: #00ff00; font-family: monospace; padding: 10px; border: none; resize: none; margin-top: 10px; border-radius: 4px; }
        .terminal { background: #050505; color: #00ff00; padding: 20px; border-radius: 8px; font-family: 'Courier New', monospace; border: 1px solid var(--accent-purple); }
        .btn-save { background: var(--accent-blue); border: none; color: white; padding: 10px; margin-top: 10px; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>

<div id="auth-screen">
    <div class="auth-tabs">
        <span id="tab-login" class="auth-tab active" onclick="switchAuth('login')">Вход</span>
        <span style="color: #444;">|</span>
        <span id="tab-register" class="auth-tab" onclick="switchAuth('register')">Register</span>
    </div>

    <div class="auth-container">
        <h2 id="auth-title" style="color: var(--accent-blue); margin-top: 0;">Вход в CBRcats</h2>
        
        <input type="email" id="auth-email" placeholder="Email">
        <input type="password" id="auth-pass" placeholder="Пароль">
        
        <button class="auth-btn" id="auth-submit-btn" onclick="handleAuth()">Войти</button>
        
        <p style="font-size: 12px; color: var(--text-gray); margin-top: 15px;">
            Нет аккаунта? Данные сохраняются локально.
        </p>
    </div>
</div>

<div id="main-ui">
    <div id="sidebar">
        <button class="nav-btn active" onclick="showWindow('game')" title="Игровая">🌍</button>
        <button class="nav-btn" onclick="showWindow('profile')" title="Мой кот">🐱</button>
        <button class="nav-btn" onclick="showWindow('chat')" title="Чат">💬</button>
        <button class="nav-btn" onclick="showWindow('news')" title="Новости">📰</button>
        <button class="nav-btn admin-only" id="admin-btn" onclick="showWindow('admin')" title="Панель разработчика">⚙️</button>
        <button class="nav-btn" style="margin-top: auto; color: #ff5555;" onclick="logout()">🚪</button>
    </div>

    <div id="content-area">
        <div id="top-bar">
            <div id="location-name">Локация: Одинокая поляна</div>
            <div id="user-info-top" style="color: var(--accent-blue); font-weight: bold;"></div>
        </div>

        <div id="game" class="window active" style="padding:0; position:relative; height: 100%;" onclick="movePlayer(event)">
            <div id="player" style="left: 100px; top: 100px;">
                <div style="font-size: 12px; margin-bottom: 5px; text-shadow: 1px 1px 2px black; font-weight: bold;" id="player-name-label"></div>
                <img src="https://i.ibb.co/cKG0hn9S/IMG-8055.png" class="player-avatar" id="cat-sprite">
            </div>

            <div id="right-panel">
                <div style="display:flex; gap:10px; align-items:center;">
                    <img src="https://catwar.net/avatar/1583508.jpg" width="60" style="border-radius:4px; border: 1px solid var(--accent-blue);">
                    <div>
                        <div id="profile-name" style="font-weight:bold;"></div>
                        <div id="profile-id" style="font-size:12px; color: gold;"></div>
                    </div>
                </div>
                <div style="margin-top:15px; font-size:13px; color: #00ff00;">Блокнот:</div>
                <textarea id="notepad"></textarea>
                <button class="btn-save" onclick="saveNotepad()">💾 Сохранить изменения</button>
            </div>
        </div>

        <div id="profile" class="window">
            <h1>Мой персонаж</h1>
            <div style="background: var(--panel-bg); padding: 20px; border-radius: 10px;">
                <p><strong>Статус:</strong> <span id="p-status">Наблюдает.</span></p>
                <p><strong>Сторона:</strong> <span id="p-side">Племя Звездной Пыли</span></p>
            </div>
        </div>

        <div id="chat" class="window">
            <h1>Общий чат</h1>
            <div id="chat-box" style="height: 300px; background: #0b0e0e; border-radius: 8px; padding: 15px; overflow-y: auto; margin-bottom: 10px;"></div>
            <div style="display: flex; gap: 10px;">
                <input type="text" id="chat-input" placeholder="Введите сообщение..." style="flex: 1; padding: 10px; background: #1e2424; border: 1px solid #333; color: white;">
                <button class="btn-save" style="margin:0;" onclick="sendMsg()">Отправить</button>
            </div>
        </div>

        <div id="admin" class="window">
            <h1 style="color: var(--accent-purple);">Terminal: Admin Access</h1>
            <div class="terminal">> Система онлайн...</div>
        </div>

        <div id="news" class="window">
            <h1>Новости мира</h1>
            <p>Интерфейс успешно обновлен!</p>
        </div>
    </div>
</div>

<script>
    const ADMIN_CREDS = { email: "hmjmhm14@gmail.com", pass: "Towuoponchik12345999tfwwxh66" };
    let currentUser = null;
    let lastX = 100;
    let authMode = 'login';

    function switchAuth(mode) {
        authMode = mode;
        const loginTab = document.getElementById('tab-login');
        const regTab = document.getElementById('tab-register');
        const title = document.getElementById('auth-title');
        const btn = document.getElementById('auth-submit-btn');

        if(mode === 'login') {
            loginTab.classList.add('active');
            regTab.classList.remove('active');
            title.innerText = "Вход в CBRcats";
            btn.innerText = "Войти";
        } else {
            regTab.classList.add('active');
            loginTab.classList.remove('active');
            title.innerText = "Регистрация";
            btn.innerText = "Создать аккаунт";
        }
    }

    function handleAuth() {
        const email = document.getElementById('auth-email').value;
        const pass = document.getElementById('auth-pass').value;

        if (!email || !pass) { alert("Заполните все поля!"); return; }

        if (email === ADMIN_CREDS.email && pass === ADMIN_CREDS.pass) {
            currentUser = { id: 1, name: "Частокол", role: "Разработчик", email: email };
        } else {
            currentUser = { id: Math.floor(Math.random()*900) + 100, name: "Кот_" + email.split('@')[0], role: "Игрок", email: email };
        }
        loginSuccess();
    }

    function loginSuccess() {
        document.getElementById('auth-screen').style.display = 'none';
        document.getElementById('main-ui').style.display = 'flex';
        document.getElementById('user-info-top').innerText = `${currentUser.name} [ID: ${currentUser.id}]`;
        document.getElementById('profile-name').innerText = currentUser.name;
        document.getElementById('profile-id').innerText = `ID: ${currentUser.id}`;
        document.getElementById('player-name-label').innerText = currentUser.name;

        if(currentUser.id === 1) document.getElementById('admin-btn').style.display = 'flex';
        const savedNote = localStorage.getItem('notepad_' + currentUser.id);
        if(savedNote) document.getElementById('notepad').value = savedNote;
    }

    function showWindow(winId) {
        document.querySelectorAll('.window').forEach(w => w.classList.remove('active'));
        document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
        document.getElementById(winId).classList.add('active');
        event.currentTarget.classList.add('active');
    }

    function movePlayer(e) {
        if(e.target.id === 'game') {
            const player = document.getElementById('player');
            const sprite = document.getElementById('cat-sprite');
            const rect = e.target.getBoundingClientRect();
            const x = e.clientX - rect.left - 42;
            const y = e.clientY - rect.top - 60;
            
            sprite.style.transform = (x > lastX) ? "scaleX(1)" : "scaleX(-1)";
            player.style.left = x + 'px';
            player.style.top = y + 'px';
            lastX = x;
        }
    }

    function saveNotepad() {
        localStorage.setItem('notepad_' + currentUser.id, document.getElementById('notepad').value);
        alert("Сохранено!");
    }

    function sendMsg() {
        const input = document.getElementById('chat-input');
        if(input.value.trim() !== "") {
            const chatBox = document.getElementById('chat-box');
            chatBox.innerHTML += `<div><span style="color:var(--accent-blue)">${currentUser.name}</span>: ${input.value}</div>`;
            input.value = "";
            chatBox.scrollTop = chatBox.scrollHeight;
        }
    }

    function logout() { location.reload(); }
</script>

</body>
</html>
