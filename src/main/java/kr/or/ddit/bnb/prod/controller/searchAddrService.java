package kr.or.ddit.bnb.prod.controller;

import java.io.UnsupportedEncodingException;
import java.net.*;
import java.util.*;
import java.io.*;

public class searchAddrService {
	private static searchAddrService service;
	
	private searchAddrService() {}
	
	public static searchAddrService getInstance() {
		if(service == null) service = new searchAddrService();
		return service;
	}

//	public static void main(String[] args) {
//		        String clientId = "SpXNBDoPlP7PpQW6aXqU"; //애플리케이션 클라이언트 아이디값"
//		        String clientSecret = "akmG94jcSk"; //애플리케이션 클라이언트 시크릿값"
//
//
//		        String text = null;
//		        try {
//		            text = URLEncoder.encode("대덕인재개발원", "UTF-8");
//		        } catch (UnsupportedEncodingException e) {
//		            throw new RuntimeException("검색어 인코딩 실패",e);
//		        }
//
//
//		        String apiURL = "https://openapi.naver.com/v1/search/local?query=" + text;    // json 결과
//		        //String apiURL = "https://openapi.naver.com/v1/search/blog.xml?query="+ text; // xml 결과
//
//
//		        Map<String, String> requestHeaders = new HashMap<>();
//		        requestHeaders.put("X-Naver-Client-Id", clientId);
//		        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
//		        String responseBody = get(apiURL,requestHeaders);
//
//
//		        System.out.println(responseBody);
//	}
	
	public String getSearchInfo(String addr) {
		 	String clientId = "SpXNBDoPlP7PpQW6aXqU"; //애플리케이션 클라이언트 아이디값"
	        String clientSecret = "akmG94jcSk"; //애플리케이션 클라이언트 시크릿값"


	        String text = null;
	        try {
	            text = URLEncoder.encode(addr, "UTF-8");
	        } catch (UnsupportedEncodingException e) {
	            throw new RuntimeException("검색어 인코딩 실패",e);
	        }


	        String apiURL = "https://openapi.naver.com/v1/search/local?query=" + text + "&display=5";    // json 결과
	        //String apiURL = "https://openapi.naver.com/v1/search/blog.xml?query="+ text; // xml 결과


	        Map<String, String> requestHeaders = new HashMap<>();
	        requestHeaders.put("X-Naver-Client-Id", clientId);
	        requestHeaders.put("X-Naver-Client-Secret", clientSecret);
	        String responseBody = get(apiURL,requestHeaders);


	        return responseBody;
	}
	
    private static String get(String apiUrl, Map<String, String> requestHeaders){
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }


            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }


    private static HttpURLConnection connect(String apiUrl){
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }


    private static String readBody(InputStream body){
        InputStreamReader streamReader = new InputStreamReader(body);


        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
            StringBuilder responseBody = new StringBuilder();


            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }


            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
    }

}
