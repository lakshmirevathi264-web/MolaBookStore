<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cart" value="${sessionScope.cart}" />
<!DOCTYPE html><html><head><title>Checkout</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container col-md-6 mt-4"><h2 class="mb-4">Checkout and Payment</h2>
<c:if test="${empty cart || cart.size() == 0}"><div class="alert alert-warning">Your cart is empty. <a href="catalog">Go to Catalog</a></div></c:if>
<c:if test="${not empty cart and cart.size() > 0}">
<c:set var="totalPrice" value="${0}" /><c:forEach var="entry" items="${cart}"><c:set var="book" value="${entry.key}" /><c:set var="quantity" value="${entry.value}" /><c:set var="totalPrice" value="${totalPrice + (book.price * quantity)}" /></c:forEach>
<div class="card shadow-lg mb-4"><div class="card-body bg-light">
<h5 class="card-title">Order Total: <span class="text-success"><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="$" /></span></h5></div></div>
<div class="card shadow"><div class="card-header bg-success text-white">Payment Details (Simulation)</div>
<div class="card-body"><form action="payment" method="post">
<div class="mb-3"><label for="cardName" class="form-label">Name on Card</label><input type="text" class="form-control" id="cardName" required></div>
<div class="mb-3"><label for="cardNumber" class="form-label">Card Number</label><input type="text" class="form-control" id="cardNumber" pattern="\d{16}" title="16 digits" required></div>
<button type="submit" class="btn btn-success w-100">Pay Now</button></form></div></div></c:if></div></body></html>
