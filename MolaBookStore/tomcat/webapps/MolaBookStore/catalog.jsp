<%@ page import="java.util.List" %>
<%@ page import="com.bookstore.model.Book" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Book Catalog – Mola Book Store</title>

	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

	<style>
		body {
			background: #f7f7f7;
		}
		.navbar-brand {
			font-weight: bold;
			font-size: 1.3rem;
		}
		.book-card {
			border-radius: 15px;
			overflow: hidden;
			box-shadow: 0 4px 12px rgba(0,0,0,0.1);
			transition: transform .2s;
		}
		.book-card:hover {
			transform: translateY(-5px);
		}
		.price {
			font-size: 20px;
			font-weight: bold;
			color: #0275d8;
		}
	</style>
</head>

<body>

<!-- NAV BAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container">
		<a class="navbar-brand" href="<%= request.getContextPath() %>/catalog">📚 Mola Book Store</a>
		<div class="collapse navbar-collapse">
			<ul class="navbar-nav ms-auto">
				<li class="nav-item"><a href="<%= request.getContextPath() %>/cart" class="nav-link">Cart</a></li>
				<li class="nav-item"><a href="<%= request.getContextPath() %>/logout" class="nav-link">Logout</a></li>
			</ul>
		</div>
	</div>
</nav>

<!-- PAGE TITLE -->
<div class="container mt-4">
	<h2 class="mb-4 text-center">Book Catalog</h2>

	<div class="row">

		<!-- Start JSP Loop -->
		<%
			List<Book> books = (List<Book>) request.getAttribute("books");
			if (books != null && !books.isEmpty()) {
				for (Book b : books) {
		%>

		<div class="col-md-4 mb-4">
			<div class="card book-card">
				<!-- Replace with real image later -->
				<img src="<%= request.getContextPath() %>/assets/img/book_default.jpg" class="card-img-top" height="200">

				<div class="card-body">
					<h5 class="card-title"><%= b.getTitle() %></h5>
					<p class="card-text text-muted">Author: <%= b.getAuthor() %></p>
					<p class="price">₹ <%= b.getPrice() %></p>

					<form action="<%= request.getContextPath() %>/addToCart" method="post" data-ajax="true" class="add-to-cart-form">
						<input type="hidden" name="bookId" value="<%= b.getId() %>">
						<button class="btn btn-success w-100">Add to Cart</button>
					</form>
				</div>
			</div>
		</div>

		<%
				}
			} else {
		%>

		<h4 class="text-center text-muted">No books available</h4>

		<% } %>
		<!-- End JSP Loop -->

	</div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- AJAX add-to-cart handler -->
<div id="alert-container" style="position:fixed;top:1rem;right:1rem;z-index:1050"></div>
<script>
	function showAlert(msg, isError) {
		const container = document.getElementById('alert-container');
		const el = document.createElement('div');
		el.className = 'alert ' + (isError ? 'alert-danger' : 'alert-success') + ' alert-dismissible fade show';
		el.role = 'alert';
		el.innerHTML = msg + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
		container.appendChild(el);
		setTimeout(() => { try { el.classList.remove('show'); el.classList.add('hide'); el.remove(); } catch(e){} }, 3500);
	}

	document.addEventListener('DOMContentLoaded', function(){
		document.querySelectorAll('form[data-ajax="true"]').forEach(form => {
			form.addEventListener('submit', async function(ev){
				ev.preventDefault();
				const action = form.action;
				const formData = new FormData(form);
				try {
					const resp = await fetch(action, { method: 'POST', body: formData, headers: { 'X-Requested-With': 'XMLHttpRequest' } });
					if (resp.headers.get('Content-Type') && resp.headers.get('Content-Type').includes('application/json')) {
						const json = await resp.json();
						if (json.success) { showAlert(json.message, false); }
						else { showAlert(json.message || 'Request failed', true); }
					} else if (resp.ok) {
						showAlert('Added to cart', false);
					} else if (resp.status === 403) {
						showAlert('Please login to add items to cart', true);
						window.location = '<%= request.getContextPath() %>/login';
					} else {
						showAlert('Error: ' + resp.status, true);
					}
				} catch (err) {
					showAlert('Network error', true);
				}
			});
		});
	});
</script>
</body>
</html>
