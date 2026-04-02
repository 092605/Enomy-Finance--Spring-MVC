package com.enomy.dao.EFuser;

import java.time.LocalDate;
import java.util.List;

import com.enomy.model.EFuser.LoginActivity;

public interface LoginActivityDao {

    void save(LoginActivity activity);

    List<LoginActivity> findAllByUserId(Long userId);

    List<LoginActivity> findByUserIdAndDateRange(Long userId, LocalDate fromDate, LocalDate toDate);

    List<LoginActivity> findFailedByUserIdAndDateRange(Long userId, LocalDate fromDate, LocalDate toDate);

    int countFailedToday(Long userId);

    int countFailedThisMonth(Long userId);

    LoginActivity findLastFailedLogin(Long userId);

    LoginActivity findLastSuccessfulLogin(Long userId);
}