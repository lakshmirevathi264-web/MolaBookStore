<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mola Book Store - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #5c6bc0;
            --primary-dark: #4a59a7;
            --bg: #f4f4f4;
            --card-bg: #ffffff;
            --muted: #6c757d;
            --radius: 12px;
        }
        html, body { height: 100%; }
        body {
            font-family: Inter, Arial, sans-serif;
            background-color: var(--bg);
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }
        .login-wrapper { width: 100%; max-width: 420px; }
        .login-card {
            background: var(--card-bg);
            padding: 28px;
            border-radius: var(--radius);
            box-shadow: 0 8px 30px rgba(30, 41, 59, 0.08);
        }
        .login-header { text-align: center; margin-bottom: 18px; }
        .login-header h3 { margin: 0; color: #212529; }
        .form-label { font-weight: 600; color: #212529; }
        .btn-primary-custom { background: var(--primary); border: none; color: #fff; }
        .btn-primary-custom:hover { background: var(--primary-dark); }
        .form-foot { text-align: center; margin-top: 12px; color: var(--muted); }
        .form-row { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .remember-wrap { display: flex; align-items: center; gap: 8px; }
        @media (max-width: 420px) {
            .login-card { padding: 20px; }
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">
        <div class="login-header">
            <h3>Sign In</h3>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form id="loginForm" action="<%= request.getContextPath() %>/login" method="post" novalidate>
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" id="username" name="username" class="form-control" required aria-required="true" />
                <div class="invalid-feedback">Please enter your username.</div>
            </div>

            <div class="mb-2">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                    <input type="password" id="password" name="password" class="form-control" required aria-required="true" />
                    <button type="button" class="btn btn-outline-secondary" id="togglePassword" aria-label="Show password">Show</button>
                </div>
                <div class="invalid-feedback">Please enter your password.</div>
            </div>

            <div class="form-row mt-3 mb-3">
                <div class="remember-wrap">
                    <input type="checkbox" id="remember" name="remember" />
                    <label for="remember" class="mb-0">Remember me</label>
                </div>
                <a href="<%= request.getContextPath() %>/signup" class="small">Create account</a>
            </div>

            <button type="submit" class="btn btn-primary btn-primary-custom w-100">Login</button>
        </form>

        <div class="form-foot">
            <small>© Mola Book Store</small>
        </div>
    </div>
</div>

<script>
    (function() {
        const form = document.getElementById('loginForm');
        const username = document.getElementById('username');
        const password = document.getElementById('password');
        const toggle = document.getElementById('togglePassword');
        const remember = document.getElementById('remember');

        try {
            const saved = localStorage.getItem('mola_remember_username');
            if (saved) {
                username.value = saved;
                remember.checked = true;
            }
        } catch (e) { }

        toggle.addEventListener('click', function() {
            if (password.type === 'password') { password.type = 'text'; toggle.textContent = 'Hide'; }
            else { password.type = 'password'; toggle.textContent = 'Show'; }
        });

        form.addEventListener('submit', function(e) {
            let valid = true;
            if (!username.value.trim()) { username.classList.add('is-invalid'); valid = false; } else { username.classList.remove('is-invalid'); }
            if (!password.value) { password.classList.add('is-invalid'); valid = false; } else { password.classList.remove('is-invalid'); }
            if (!valid) { e.preventDefault(); return false; }
            try {
                if (remember.checked) { localStorage.setItem('mola_remember_username', username.value.trim()); }
                else { localStorage.removeItem('mola_remember_username'); }
            } catch (err) { }
            return true;
        });
    })();
</script>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<title>Mola Book Store - Login</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
		.error-message { color: red; text-align: center; margin-bottom: 15px; }
	</style>
<body>
<div class="container col-md-4 mt-5">
	<div class="card shadow-lg">
		<div class="card-header bg-primary text-white text-center">
			<h3>Sign In</h3>
		<div class="card-body">
			<c:if test="${not empty errorMessage}">
				<div class="alert alert-danger">${errorMessage}</div>
			</c:if>
			<c:if test="${not empty error}">
				<div class="alert alert-danger">${error}</div>
			<form action="<%= request.getContextPath() %>/login" method="post">
				<div class="mb-3">
					<label for="username" class="form-label">Username</label>
					<input type="text" class="form-control" id="username" name="username" required>
				</div>
				<div class="mb-3">
					<label for="password" class="form-label">Password</label>
					<input type="password" class="form-control" id="password" name="password" required>
				</div>
				<button type="submit" class="btn btn-primary w-100">Login</button>
			</form>
		</div>
		<div class="card-footer text-center">
			<p>Don't have an account? <a href="<%= request.getContextPath() %>/signup">Sign Up Here</a></p>
		</div>
	</div>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><title>Login</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><div class="container col-md-4 mt-5"><div class="card shadow-lg"><div class="card-header bg-primary text-white text-center"><h3>Login</h3></div>
<div class="card-body"><c:if test="${not empty param.logout}"><div class="alert alert-success">Logged out successfully.</div></c:if>
<c:if test="${not empty param.signup}"><div class="alert alert-success">Registration successful!</div></c:if>
<c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>
<form action="login" method="post"><div class="mb-3"><label for="username" class="form-label">Username</label><input type="text" class="form-control" id="username" name="username" required></div>
<div class="mb-3"><label for="password" class="form-label">Password</label><input type="password" class="form-control" id="password" name="password" required></div>
<button type="submit" class="btn btn-primary w-100">Login</button></form></div>
<div class="card-footer text-center">Don't have an account? <a href="signup.jsp">Sign Up Here</a></div></div></div></body></html>
