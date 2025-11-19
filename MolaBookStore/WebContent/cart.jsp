<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cart" value="${sessionScope.cart}" />
<!DOCTYPE html><html><head><title>Shopping Cart</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container mt-4"><h2 class="mb-4">Your Shopping Cart</h2>
<c:if test="${not empty param.error}"><div class="alert alert-danger">${param.error}</div></c:if>
<c:choose><c:when test="${empty cart || cart.size() == 0}"><div class="alert alert-info" role="alert">Your cart is empty. <a href="catalog">Continue Shopping</a></div></c:when>
<c:otherwise><table class="table table-striped table-hover"><thead class="table-dark"><tr><th>Title</th><th>Author</th><th>Price</th><th>Quantity</th><th>Subtotal</th></tr></thead><tbody>
<c:set var="totalPrice" value="${0}" /><c:forEach var="entry" items="${cart}"><c:set var="book" value="${entry.key}" />
<c:set var="quantity" value="${entry.value}" /><c:set var="subtotal" value="${book.price * quantity}" /><c:set var="totalPrice" value="${totalPrice + subtotal}" />
<tr><td>${book.title}</td><td>${book.author}</td><td><fmt:formatNumber value="${book.price}" type="currency" currencySymbol="$" /></td><td>${quantity}</td>
<td><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="$" /></td></tr></c:forEach></tbody></table>
<div class="row mt-4"><div class="col-md-6 offset-md-6"><div class="card shadow-lg"><div class="card-body">
<h4 class="card-title">Order Total: <span class="text-success"><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="$" /></span></h4>
<a href="payment.jsp" class="btn btn-success w-100">Proceed to Checkout</a></div></div></div></div></c:otherwise></c:choose></div></body></html>
