<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark"><div class="container-fluid"><a class="navbar-brand" href="catalog">MolaBookStore</a>
<div class="collapse navbar-collapse" id="navbarNav">
<ul class="navbar-nav me-auto mb-2 mb-lg-0"><li class="nav-item"><a class="nav-link" href="catalog">Catalog</a></li>
<c:if test="${currentUser != null}"><li class="nav-item"><a class="nav-link" href="cart">Cart</a></li>
<c:if test="${currentUser.admin}"><li class="nav-item"><a class="nav-link text-warning" href="admin/addBook">Add Book</a></li></c:if></c:if></ul>
<ul class="navbar-nav"><c:choose><c:when test="${currentUser != null}"><li class="nav-item"><span class="nav-link text-light">Welcome, **${currentUser.username}**</span></li>
<li class="nav-item"><a class="btn btn-outline-light" href="logout">Logout</a></li></c:when>
<c:otherwise><li class="nav-item"><a class="btn btn-outline-light me-2" href="login.jsp">Login</a></li>
<li class="nav-item"><a class="btn btn-light" href="signup.jsp">Sign Up</a></li></c:otherwise></c:choose></ul></div></div></nav>
