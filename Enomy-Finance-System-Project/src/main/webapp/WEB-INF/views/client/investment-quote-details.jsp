<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quote Details</title>
</head>
<body>

<h2>Investment Quote Details</h2>

<p>Selected Plan: ${investmentResponse.planType}</p>

<hr>

<h3>1 Year Result</h3>
<p>Total Invested: £${investmentResponse.oneYear.totalInvested}</p>
<p>Min Return: £${investmentResponse.oneYear.minReturn}</p>
<p>Max Return: £${investmentResponse.oneYear.maxReturn}</p>
<p>Min Profit: £${investmentResponse.oneYear.minProfit}</p>
<p>Max Profit: £${investmentResponse.oneYear.maxProfit}</p>
<p>Min Tax: £${investmentResponse.oneYear.minTax}</p>
<p>Max Tax: £${investmentResponse.oneYear.maxTax}</p>

<hr>

<h3>5 Years Result</h3>
<p>Total Invested: £${investmentResponse.fiveYears.totalInvested}</p>
<p>Min Return: £${investmentResponse.fiveYears.minReturn}</p>
<p>Max Return: £${investmentResponse.fiveYears.maxReturn}</p>
<p>Min Profit: £${investmentResponse.fiveYears.minProfit}</p>
<p>Max Profit: £${investmentResponse.fiveYears.maxProfit}</p>
<p>Min Tax: £${investmentResponse.fiveYears.minTax}</p>
<p>Max Tax: £${investmentResponse.fiveYears.maxTax}</p>

<hr>

<h3>10 Years Result</h3>
<p>Total Invested: £${investmentResponse.tenYears.totalInvested}</p>
<p>Min Return: £${investmentResponse.tenYears.minReturn}</p>
<p>Max Return: £${investmentResponse.tenYears.maxReturn}</p>
<p>Min Profit: £${investmentResponse.tenYears.minProfit}</p>
<p>Max Profit: £${investmentResponse.tenYears.maxProfit}</p>
<p>Min Tax: £${investmentResponse.tenYears.minTax}</p>
<p>Max Tax: £${investmentResponse.tenYears.maxTax}</p>

<hr>

<br>
<a href="${pageContext.request.contextPath}/client/investment/quotes">← Back to Saved Quotes</a>

</body>
</html>