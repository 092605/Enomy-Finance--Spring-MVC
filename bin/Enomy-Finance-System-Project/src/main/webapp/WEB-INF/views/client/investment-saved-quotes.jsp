<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Saved Investment Quotes</title>
</head>
<body>

<h2>Saved Investment Quotes</h2>

<p>Total Saved Quotes: ${savedQuoteCount}</p>

<table border="1" cellpadding="10">
    <thead>
        <tr>
            <th>Quote ID</th>
            <th>Plan Type</th>
            <th>Initial Lump Sum</th>
            <th>Monthly Investment</th>
            <th>Created At</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="quote" items="${savedQuotes}">
            <tr>
                <td>${quote.id}</td>
                <td>${quote.planType}</td>
                <td>£${quote.initialLumpSum}</td>
                <td>£${quote.monthlyInvestment}</td>
                <td>${quote.createdAt}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/client/investment/quotes/${quote.id}">
                        View Details
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty savedQuotes}">
            <tr>
                <td colspan="6">No saved quotes yet.</td>
            </tr>
        </c:if>
    </tbody>
</table>

<br>
<a href="${pageContext.request.contextPath}/client/investment">← Back to Calculator</a>

</body>
</html>