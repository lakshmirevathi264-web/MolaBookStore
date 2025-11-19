<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html><head><title>Success</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><jsp:include page="/WEB-INF/header.jsp" /><div class="container col-md-6 mt-5"><div class="card text-center shadow-lg">
<div class="card-header bg-success text-white"><c:choose><c:when test="${param.type eq 'payment'}"><h1>Payment Successful!</h1></c:when><c:otherwise><h1>Success!</h1></c:otherwise></c:choose></div>
<div class="card-body"><c:choose><c:when test="${param.type eq 'payment'}"><p class="card-text fs-5">Thank you for your order!</p></c:when>
<c:otherwise><p class="card-text fs-5">Operation completed successfully.</p></c:otherwise></c:choose>
<hr><a href="catalog" class="btn btn-primary me-2">Continue Shopping</a><a href="logout" class="btn btn-secondary">Logout</a></div></div></div></body></html>
