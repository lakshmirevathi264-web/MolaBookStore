<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Sign Up – Mola Book Store</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
	<style>
		:root { --primary: #5c6bc0; --muted: #6c757d; --card-bg: #fff; --radius: 10px; }
		html,body{height:100%;}
		body { font-family: Inter, Arial, sans-serif; background:#f4f4f4; margin:0; display:flex; align-items:center; justify-content:center; padding:20px; }
		.card { border-radius: var(--radius); box-shadow: 0 8px 30px rgba(30,41,59,0.06); }
		.small-foot { text-align:center; color:var(--muted); margin-top:12px; }
	</style>
</head>
<body>
<div style="width:100%;max-width:420px;">
	<div class="card">
		<div class="card-header bg-success text-white text-center"><h3 class="mb-0">Sign Up</h3></div>
		<div class="card-body">
			<c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>
			<form id="signupForm" action="<%= request.getContextPath() %>/signup" method="post" novalidate>
				<div class="mb-3">
					<label for="username" class="form-label">Username</label>
					<input type="text" id="username" name="username" class="form-control" required />
					<div class="invalid-feedback">Please choose a username.</div>
				</div>
				<div class="mb-3">
					<label for="password" class="form-label">Password</label>
					<div class="input-group">
						<input type="password" id="password" name="password" class="form-control" required />
						<button type="button" class="btn btn-outline-secondary" id="toggleSignupPwd" aria-label="Show password">
							<i id="toggleSignupIcon" class="bi bi-eye-fill" aria-hidden="true"></i>
						</button>
					</div>
					<div class="invalid-feedback">Please provide a password (min 6 chars).</div>
				</div>
				<button type="submit" class="btn btn-success w-100">Sign Up</button>
			</form>
		</div>
		<div class="card-footer">
			<div class="small-foot">Already have an account? <a href="<%= request.getContextPath() %>/login.jsp">Login Here</a></div>
		</div>
	</div>
</div>

<script>
	(function(){
		const form = document.getElementById('signupForm');
		const username = document.getElementById('username');
		const password = document.getElementById('password');
		const toggle = document.getElementById('toggleSignupPwd');
		const icon = document.getElementById('toggleSignupIcon');
		toggle.addEventListener('click', ()=>{
			if(password.type==='password'){
				password.type='text';
				icon.classList.remove('bi-eye-fill');
				icon.classList.add('bi-eye-slash-fill');
				toggle.setAttribute('aria-label','Hide password');
			} else {
				password.type='password';
				icon.classList.remove('bi-eye-slash-fill');
				icon.classList.add('bi-eye-fill');
				toggle.setAttribute('aria-label','Show password');
			}
		});
		form.addEventListener('submit', function(e){
			let valid=true;
			if(!username.value.trim()){ username.classList.add('is-invalid'); valid=false;} else username.classList.remove('is-invalid');
			if(!password.value || password.value.length<6){ password.classList.add('is-invalid'); valid=false;} else password.classList.remove('is-invalid');
			if(!valid){ e.preventDefault(); }
		});
	})();
</script>

</body>
</html>
