


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Dashboard | Enomy Finance</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
</head>

<body class="dashboard-page">

    <div class="dashboard-layout">

        <jsp:include page="/WEB-INF/components/Authenticated/sidebar.jsp" />

        <div class="dashboard-main" id="dashboardMain">

            <jsp:include page="/WEB-INF/components/Authenticated/topbar.jsp" />

            <main class="dashboard-content">

                <!-- Welcome Section -->
                <section class="dashboard-welcome">
                    <h1>Hello, ${pageContext.request.userPrincipal.name}</h1>
                    <p class="text-muted">Here is an overview of your financial activity.</p>
                </section>

                <!-- Top Summary Cards -->
                <section class="dashboard-section">
                    <div class="row g-4">

                        <div class="col-xl-3 col-md-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Investment Quotes</h5>
                                </div>
                                <div class="dashboard-card-body">
                                    <p class="dashboard-card-value">1</p>
                                    <button class="btn-glow">View All</button>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-5 col-md-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Contribution Tracker</h5>
                                </div>
                                <div class="dashboard-card-body">
                                    <p class="mb-2">Basic Savings Plan</p>
                                    <div class="tracker-bar">
                                        <div class="tracker-bar-fill"></div>
                                    </div>
                                    <p class="text-muted mt-3 mb-2">Next Due: Aug 30, 2026</p>

                                    <div class="d-flex flex-wrap gap-2 align-items-center">
                                        <span class="tracker-progress">3 / 12 months</span>
                                        <button class="btn-glow-outline">Mark as Paid</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-4 col-md-12">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Investment Projection</h5>
                                </div>
                                <div class="dashboard-card-body">
                                    <p class="dashboard-card-value">₱150,000.00</p>
                                    <p class="text-muted mb-3">Estimated after 1 year</p>
                                    <button class="btn-glow-outline">View Projection</button>
                                </div>
                            </div>
                        </div>

                    </div>
                </section>

                <!-- Calculator Section -->
                <section class="dashboard-section">
                    <div class="section-title-wrap">
                        <h3>Enomy Finance Tools</h3>
                    </div>

                    <div class="row g-4">

                        <div class="col-lg-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Currency Converter</h5>
                                </div>

                                <div class="dashboard-card-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Base</label>
                                            <select class="form-select dashboard-select">
                                                <option>GBP</option>
                                                <option>USD</option>
                                                <option>EUR</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Target</label>
                                            <select class="form-select dashboard-select">
                                                <option>USD</option>
                                                <option>GBP</option>
                                                <option>EUR</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="dashboard-result-box mt-4">
                                        Calculation Result...
                                    </div>

                                    <div class="d-flex flex-wrap gap-2 mt-4">
                                        <input type="text" class="form-control dashboard-input" placeholder="Input amount...">
                                        <button class="btn-glow">Calculate</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Investment Calculator</h5>
                                </div>

                                <div class="dashboard-card-body investment-tool-card">
                                    <div class="investment-placeholder card-glass">
                                        <span>Investment Planning Widget</span>
                                    </div>

                                    <div class="mt-4">
                                        <button class="btn-glow">Calculate Investment</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </section>

                <!-- Bottom Panels -->
                <section class="dashboard-section">
                    <div class="row g-4">

                        <div class="col-lg-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Recent Activity</h5>
                                </div>

                                <div class="dashboard-card-body">
                                    <div class="table-responsive">
                                        <table class="table dashboard-table align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Date</th>
                                                    <th>Activity</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>Aug 15</td>
                                                    <td>USD → GBP Conversion</td>
                                                    <td><button class="btn-glow-outline btn-sm">View</button></td>
                                                </tr>
                                                <tr>
                                                    <td>Aug 10</td>
                                                    <td>Saved Investment Quote</td>
                                                    <td><button class="btn-glow-outline btn-sm">View</button></td>
                                                </tr>
                                                <tr>
                                                    <td>Jul 8</td>
                                                    <td>GBP → EUR Conversion</td>
                                                    <td><button class="btn-glow-outline btn-sm">View</button></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <div class="card-glow dashboard-card h-100">
                                <div class="dashboard-card-header">
                                    <h5>Currency Rates</h5>
                                </div>

                                <div class="dashboard-card-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Base</label>
                                            <select class="form-select dashboard-select">
                                                <option>GBP</option>
                                                <option>USD</option>
                                                <option>EUR</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Target</label>
                                            <select class="form-select dashboard-select">
                                                <option>USD</option>
                                                <option>GBP</option>
                                                <option>EUR</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="dashboard-result-box mt-4">
                                        Rate Result...
                                    </div>

                                    <div class="mt-4">
                                        <button class="btn-glow">Check Rate</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </section>

            </main>

            <jsp:include page="/WEB-INF/components/Authenticated/footer.jsp" />

        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>
</body>
</html>









<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Client Dashboard | Enomy Finance</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navbar.css">

</head>

<body>

<!-- NAVBAR -->
<jsp:include page="/WEB-INF/components/navbar.jsp"/>

<div class="container py-5">

    <div class="card shadow p-4">

        <h2 class="mb-3">Client Dashboard</h2>

        <p class="text-muted">
            Welcome,
            <strong>${loggedInEmail}</strong>
        </p>

        <hr>

        <p>
            This is the client dashboard.
            Your financial tools will appear here.
        </p>

        <form method="post" action="${pageContext.request.contextPath}/logout">
            <button class="btn btn-danger mt-3">Logout</button>
        </form>

    </div>

</div>

</body>
</html> --%>

