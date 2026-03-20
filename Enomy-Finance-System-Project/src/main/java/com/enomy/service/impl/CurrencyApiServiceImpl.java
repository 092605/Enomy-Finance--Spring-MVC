package com.enomy.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.springframework.stereotype.Service;

import com.enomy.service.CurrencyApiService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class CurrencyApiServiceImpl implements CurrencyApiService {

    @Override
    public Double getExchangeRate(String baseCurrency, String targetCurrency) {
        try {
            String urlString = "https://api.frankfurter.dev/v1/latest?base="
                    + baseCurrency
                    + "&symbols="
                    + targetCurrency;

            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);

            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                return null;
            }

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream())
            );

            StringBuilder response = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                response.append(line);
            }

            reader.close();
            connection.disconnect();

            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.toString());

            JsonNode ratesNode = root.get("rates");
            if (ratesNode != null && ratesNode.has(targetCurrency)) {
                return ratesNode.get(targetCurrency).asDouble();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}