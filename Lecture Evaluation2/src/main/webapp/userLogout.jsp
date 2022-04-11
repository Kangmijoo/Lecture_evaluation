<!-- 로그인이 된 상태인 사용자가 로그아웃을 요청했을 때 처리해주는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	session.invalidate();	//클라이언트에 모든 session정보를 파기
%>
<script>
	location.href = 'index.jsp';
</script>