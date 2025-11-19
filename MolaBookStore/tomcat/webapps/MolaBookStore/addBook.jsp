<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Add Book – Mola Book Store (Admin)</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
		:root { --card-radius: 10px; --muted: #6c757d; }
		.card { border-radius: var(--card-radius); box-shadow: 0 8px 30px rgba(30,41,59,0.06); }
		.container { max-width: 760px; }
	</style>
</head>
<body>
<jsp:include page="/WEB-INF/header.jsp" />
<div class="container mt-4">
	<h2 class="mb-4 text-warning">Add Book (Admin)</h2>
	<c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>
	<div class="card">
		<div class="card-body">
			<form id="addBookForm" action="<%= request.getContextPath() %>/admin/addBook" method="post" novalidate>
				<div class="mb-3">
					<label for="title" class="form-label">Title</label>
					<input type="text" id="title" name="title" class="form-control" required />
					<div class="invalid-feedback">Enter a book title.</div>
				</div>
				<div class="mb-3">
					<label for="author" class="form-label">Author</label>
					<input type="text" id="author" name="author" class="form-control" required />
					<div class="invalid-feedback">Enter the author name.</div>
				</div>
				<div class="mb-3">
					<label for="price" class="form-label">Price</label>
					<input type="number" step="0.01" id="price" name="price" class="form-control" required min="0.01" />
					<div class="invalid-feedback">Enter a valid price.</div>
				</div>
				<div class="mb-3">
					<label for="quantity" class="form-label">Quantity</label>
					<input type="number" id="quantity" name="quantity" class="form-control" required min="1" />
					<div class="invalid-feedback">Enter quantity (>=1).</div>
				</div>
				<button type="submit" class="btn btn-warning w-100">Add Book</button>
			</form>
		</div>
	</div>
</div>

<script>
	(function(){
		const form = document.getElementById('addBookForm');
		const title = document.getElementById('title');
		const author = document.getElementById('author');
		const price = document.getElementById('price');
		const quantity = document.getElementById('quantity');

		function showAdminAlert(msg, isError){
			let container = document.getElementById('admin-alert-container');
			if(!container){ container = document.createElement('div'); container.id = 'admin-alert-container'; container.style.position='fixed'; container.style.top='1rem'; container.style.right='1rem'; container.style.zIndex='1050'; document.body.appendChild(container); }
			const el = document.createElement('div'); el.className = 'alert ' + (isError? 'alert-danger':'alert-success') + ' alert-dismissible fade show'; el.role='alert'; el.innerHTML = msg + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>'; container.appendChild(el);
			setTimeout(()=>{ try{ el.classList.remove('show'); el.remove(); }catch(e){} }, 3500);
		}

		async function submitAjax(ev){
			ev.preventDefault();
			let valid = true;
			if(!title.value.trim()){ title.classList.add('is-invalid'); valid=false;} else title.classList.remove('is-invalid');
			if(!author.value.trim()){ author.classList.add('is-invalid'); valid=false;} else author.classList.remove('is-invalid');
			if(!price.value || parseFloat(price.value) <= 0){ price.classList.add('is-invalid'); valid=false;} else price.classList.remove('is-invalid');
			if(!quantity.value || parseInt(quantity.value) < 1){ quantity.classList.add('is-invalid'); valid=false;} else quantity.classList.remove('is-invalid');
			if(!valid){ return; }

			const fd = new FormData(form);
			try{
				const resp = await fetch(form.action, { method: 'POST', body: fd, headers: { 'X-Requested-With': 'XMLHttpRequest' } });
				const ct = resp.headers.get('Content-Type') || '';
				if(ct.includes('application/json')){
					const json = await resp.json();
					if(json.success){ showAdminAlert(json.message || 'Book added', false); form.reset(); }
					else { showAdminAlert(json.message || 'Add failed', true); }
				} else if(resp.ok){ showAdminAlert('Book added (redirect may follow)', false); form.reset(); }
				else if(resp.status === 403){ showAdminAlert('Forbidden: admin login required', true); window.location = '<%= request.getContextPath() %>/login'; }
				else { showAdminAlert('Server error: '+resp.status, true); }
			}catch(err){ showAdminAlert('Network error', true); }
		}

		form.addEventListener('submit', submitAjax);
	})();
</script>

</body>
</html>
