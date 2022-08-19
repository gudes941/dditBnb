<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String cate = request.getParameter("cate");
Cookie[] cookies = request.getCookies();

String user = "";
String check = "";

if(cookies != null){
	for(Cookie cookie : cookies){
		if(cookie.getName().equals("user")){
			user = cookie.getValue();
		}
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대덕비앤비:도움말</title>
<link rel="stylesheet" href="../style/reset.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Fira+Sans:ital,wght@1,900&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<script type="text/javascript" src='../js/jquery-3.6.0.min.js'></script>
<script type="text/javascript" src="../js/util.js"></script>
<script type="text/javascript" src="../js/login.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="../style/qnaBoardStyle.css">
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script src="../js/kakaoLogin.js"></script>
</head>
<script type="text/javascript">
$(function(){
	$.ajax({
		url: '/dditBnb/QnAController.do',
		type:'post',
		data : {
			"cate" : "<%= cate %>"
		},
		success: function(res){
			code = "";
			$.each(res, function(i, v) {
				code += "<li class='qnaItem' id='" + v.qna_id + "'>" + v.qna_title + "</li>";			
			})
			$('#qnaBoard_list').html(code);			
		},
		error : function(xhr){
			alert("상태 : " + xhr.status);
		},
		dataType:'json'
	})
	
	$('#qnaBoard_list').on('click' ,'.qnaItem' , function(){
		qnatitle = $(this).text();
		//console.log($(this).attr("id"));
				
		$('#qnaDetailModal').modal('show');
		
		$.ajax({
			url: '/dditBnb/QnADetailController.do',
			type:'post',
			data : {
				"cate" : "<%= cate %>",
				"qnaId" : $(this).attr("id")
			},
			success: function(res){
				$('#qnaDetailModal #qna_id').val(res.qna_id);			
				$('#qnaDetailModal #memId').val(res.mem_id);			
				$('#qnaDetailModal #date').val(res.qna_date);			
				$('#qnaDetailModal #qtitle').val(res.qna_title);			
				$('#qnaDetailModal #content').val(res.qna_con);		
				
				if(res.mem_id == "<%= user%>"){
					
					code = "";
					code += "<button type='button' class='btn btn-danger' data-dismiss='modal' id='updateQna'>수정</button>";
					code += "<button type='button' class='btn btn-danger' data-dismiss='modal' id='deleteQna'>삭제</button>";
					
					$('#qnaDetailModal .modal-footer').html(code);
					
				}else{
					code = "";
					$('#qnaDetailModal .modal-footer').html(code);
				}
			},
			error : function(xhr){
				alert("상태 : " + xhr.status);
			},
			dataType:'json'
		})
		
		
		//민규
		//댓글
		$.ajax({
			url: '/dditBnb/AnsSelect.do',
			type:'post',
			data : {
				"cate" : "<%= cate %>",
				"qnaId" : $(this).attr("id")
			},
			success: function(res){
				code = "";

				if(res.ans_id != null) {
					code += "<label for='ansdate'>답변날짜</label>";
					code += "<input type='text' class='form-control' id='ansdate' value='" + res.ans_date + "'disabled><br>";
					code += "<label for='anscon'>답변내용</label>";
					code += "<textarea rows='3' cols='60' class='form-control' id='anscon' disabled>" + res.ans_con + "</textarea>";
				} else {
					code += "<p>아직 답변하지 않았습니다.</p>";
					if("<%=user%>" == "admin"){
						code += "<p class='answer_insert'>";
						code += "	<textarea rows='3' cols='60' class='form-control' style='background:white; border-radius : 15px;'></textarea>";
						code += "	<input type='button' class='action btn btn-outline-danger btn-sm' name='reply' value='등록'>";
						code += "</p>";
					}
				}
				
				$('.card-body').html(code);	
			},
			error : function(xhr){
				alert("상태 : " + xhr.status);
			},
			dataType:'json'
		})
	})
	
	//민규
	qna_id ='';
	ans_con ='';
	$('#qnaDetailModal').on('click', '.action', function(){
      actionName = $(this).attr('name');
      qna_id = $('#qnaDetailModal #qna_id').val();
      
      if(actionName == "reply"){
         // 입력한 내용 - ans_con
         // 글번호  - qna_id
         ans_con = $(this).prev().val();
         
         replyInsert(this);
         
         $(this).prev().val("");
         
      }
    })
    
    //민규
    //댓글 등록
    var replyInsert = function(target){
		$.ajax({
			url : '/dditBnb/qnaAnsInsert.do',
			type : 'post',
			data : {
				"qna_id" : qna_id,
				"ans_con" : ans_con
			},
			success : function(res){
				if(res > 0){
					alert("댓글 입력 성공");
					location.reload();
				}
			},
			error : function(xhr){
				alert("상태 : " + xhr.status);
			},
			dataType : 'json'
		})
	}
	
	
	$('#insert').on('click', function(){		
		$.ajax({
			url: '/dditBnb/QnaInsert.do',
			type: 'post',
			data : {
				"cate" : "<%=cate%>",
				"user" : "<%=user%>",
				"title" : $('#title').val(),
				"contest" : $('#qcontest').val()	
			},
			success: function(res){
				if(res != null){
					alert(res)
					location.reload();
				}	
			},
			error : function(xhr){
				alert("상태 : " + xhr.status);
			}
	   })
	})
	
	$('#qnaDetailModal').on('click' ,'#deleteQna' , function(){
		$.ajax({
			url: '/dditBnb/QnADelete.do',
			type:'post',
			data : {
				"qnaId" : $(this).parents("#qnaDetailModal").find('#qna_id').val()
			},
			success: function(res){
				alert(res);
				location.reload();
			},
			error : function(xhr){
				alert("상태 : " + xhr.status);
			}
		})
		
	}) 
})

</script>
<body>
 <div id="help_container">
 	<header>
 		<div class="headerTop">
			<div class="logoContainer">
				<a href="./index.jsp">
					<svg width="35" height="32" fill="black" style="display:block;">
						<path d="
							M 16 1 c 2.008 0 3.463 0.963 4.751 3.269 l 0.533 1.025 c 1.954 3.83 6.114 12.54 7.1 14.836 l 0.145 0.353 c 0.667 1.591 0.91 2.472 0.96 3.396 l 0.01 0.415 l 0.001 0.228 c 0 4.062 -2.877 6.478 -6.357 6.478 c -2.224 0 -4.556 -1.258 -6.709 -3.386 l -0.257 -0.26 l -0.172 -0.179 h -0.011 l -0.176 0.185 c -2.044 2.1 -4.267 3.42 -6.414 3.615 l -0.28 0.019 l -0.267 0.006 C 5.377 31 2.5 28.584 2.5 24.522 l 0.005 -0.469 c 0.026 -0.928 0.23 -1.768 0.83 -3.244 l 0.216 -0.524 c 0.966 -2.298 6.083 -12.989 7.707 -16.034 C 12.537 1.963 13.992 1 16 1 Z m 0 2 c -1.239 0 -2.053 0.539 -2.987 2.21 l -0.523 1.008 c -1.926 3.776 -6.06 12.43 -7.031 14.692 l -0.345 0.836 c -0.427 1.071 -0.573 1.655 -0.605 2.24 l -0.009 0.33 v 0.206 C 4.5 27.395 6.411 29 8.857 29 c 1.773 0 3.87 -1.236 5.831 -3.354 c -2.295 -2.938 -3.855 -6.45 -3.855 -8.91 c 0 -2.913 1.933 -5.386 5.178 -5.42 c 3.223 0.034 5.156 2.507 5.156 5.42 c 0 2.456 -1.555 5.96 -3.855 8.907 C 19.277 27.766 21.37 29 23.142 29 c 2.447 0 4.358 -1.605 4.358 -4.478 l -0.004 -0.411 c -0.019 -0.672 -0.17 -1.296 -0.714 -2.62 l -0.248 -0.6 c -1.065 -2.478 -5.993 -12.768 -7.538 -15.664 C 18.053 3.539 17.24 3 16 3 Z m 0.01 10.316 c -2.01 0.021 -3.177 1.514 -3.177 3.42 c 0 1.797 1.18 4.58 2.955 7.044 l 0.21 0.287 l 0.174 -0.234 c 1.73 -2.385 2.898 -5.066 2.989 -6.875 l 0.006 -0.221 c 0 -1.906 -1.167 -3.4 -3.156 -3.421 h -0.001 Z
						">
						</path>
					</svg>
					<span id="logoTitle">
						도움말 센터
					</span>
				</a>
			</div>
			<div class="userContent">
				<button class="userMenu">
					<span class="material-icons">
						reorder
					</span>
					<span class="material-icons" style="font-size:35px;">
						account_circle
					</span>
				</button>
			</div>
			<%
			if(user.equals("")){	
		%>
				<ul id="userMenu_list" style="display: none;">
					<li class="userMenu_item" id="signUp" data-toggle="modal" data-target="#signUpForm">회원가입</li>
					<li class="userMenu_item" id="login" data-toggle="modal" data-target="#loginForm">로그인</li>
					<hr>
					<li class="userMenu_item" id="doHost"><a href="./hosthome.jsp">숙소 호스트 되기</a></li>
					<li class="userMenu_item" id="help"><a href="./helpBoard.jsp">도움말</a></li>
				</ul>
		<%		
			}else if(user.equals("admin")) {
		%>
				<ul id="userMenu_list" style="display: none;">
					<li class="userMenu_item" id="memberManage"><a href="./managementMember.jsp">회원관리</a></li>
					<li class="userMenu_item" id="prodManage"><a href="./managementProd.jsp">숙소관리</a></li>
					<li class="userMenu_item" id="help"><a href="./helpBoard.jsp">고객센터관리</a></li>
					<li class="userMenu_item" id="logOut">로그아웃</li>
				</ul>
		<%
			}else{
				%>
				<ul id="userMenu_list" style="display: none;">
					<li class="userMenu_item" id="message">메세지</li>
					<li class="userMenu_item" id="myPage"><a href="./myPage.jsp">마이페이지</a></li>
					<hr>
					<li class="userMenu_item" id="prodManage"><a href="./manageHostprod.jsp">숙소관리</a></li>
					<li class="userMenu_item" id="help"><a href="./helpBoard.jsp">도움말</a></li>
					<li class="userMenu_item" id="logOut">로그아웃</li>
				</ul>
		<%
			}
		%>
		</div>
		<div class="headerBody">
			<h1>무엇을 도와드릴까요?</h1>
		</div>
 	</header>
 	<main>

 		<div id="qnaReser">
 			<h2><%= cate %></h2>
 			<%
 				if(!user.equals("") && !user.equals("admin")){
			%> 				
		 			<button data-toggle="modal" data-target="#qnaModal">질문하기</button>
 			<%	
 				}
 			%>
 			<div id="helpSelect_kind">
 				<ul id="qnaBoard_list" class="boardlist">
 					
 				</ul>	
 			</div>
 		</div>
 		<%
			if(user.equals("")){
		%> 					
		 		<div id="help_loginForm">
		 			<div>
		 				<p style="font-weight: bold; font-size: 30px">대덕비앤비가 도와드립니다</p>
		 				<p>대덕비앤비 이용에 도움을 받으려면 로그인하세요.</p>
		 			</div>
		 			<button data-toggle="modal" data-target="#loginForm">로그인</button>
		 		</div>
		<%	
			}
		%>
 		
 	</main>
 </div>
<footer id="footer">
	<div id="footer_list">
		<div id="footer_support">
			<h3>대덕비앤비 지원</h3>
			<ul>
				<li>도움말 센터</li>
				<li>안전 정보</li>
				<li>예약 취소 옵션</li>
				<li>에어비앤비의 코로나19 대응 방안</li>
				<li>장애인 지원</li>
				<li>이웃 민원 신고</li>
			</ul>
		</div>
		<div id="footer_community">
			<h3>커뮤니티</h3>
			<ul>
				<li>dditBnB.org:재난 구호 숙소</li>
				<li>아프간 난민 지원</li>
				<li>차별 철폐를 위한 노력</li>
			</ul>
		</div>
		<div id="footer_hosting">
			<h3>호스팅</h3>
			<ul>
				<li>호스팅 시작하기</li>
				<li>커뮤니티 포럼 방문하기</li>
				<li>에어커버:호스트를 위한 보호 프로그램</li>
				<li>책임감 있는 호스팅</li>
				<li>호스팅 자료 둘러보기</li>
			</ul>
		</div>
		<div id="footer_introduce">
			<h3>소개</h3>
			<ul>
				<li>뉴스룸</li>
				<li>채용정보</li>
				<li>새로운 기능에 대해 알아보기</li>
				<li>투자자 정보</li>
				<li>대덕비앤비 공동창업자의 메시지</li>
				<li>대덕비앤비 Luxe</li>
			</ul>
		</div>
	</div>
	<div id="footer_mark">
		<span>
			&copy; 2022 dditBnB,Inc
		</span>
	</div>
</footer>
<!-- signup modal -->
	<div class="modal fade" id="signUpForm">
	  <div class="modal-dialog">
	    <div class="modal-content">
	
	      <!-- Modal Header -->
	      <div class="modal-header">
	        <h4 class="modal-title">회원가입</h4>
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	      </div>
	
	      <!-- Modal body -->
	      <div class="modal-body">
	        <form class="was-validated">
			  <div class="form-groupd">
			    <input type="text" class="form-control" id="uname" placeholder="이름을 입력해주세요." name="uname" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <input type="text" class="form-control" id="uid" placeholder="아이디를 입력해주세요." name="uid" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <input type="password" class="form-control" id="password" placeholder="8자~12자 사이의 비밀번호 입력" name="password" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <input type="password" class="form-control" id="pwdCheck" placeholder="비밀번호를 다시 입력해주세요." name="pwdCheck" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <input type="date" class="form-control" id="ubirth" name="ubirth" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <input type="text" class="form-control" id="email" placeholder="이메일을 입력해주세요." name="email" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <input type="text" class="form-control" id="tel" placeholder="전화번호를 입력해주세요." name="tel" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <input type="text" class="form-control" id="addr" placeholder="주소를 입력해주세요." name="addr" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			    <select name="findPwd" id="findPwd" style="width:90%">
			    	<option>
			    		보물 1호는?
			    	</option>
			    	<option>
			    		졸업한 고등학교는?
			    	</option>
			    	<option>
			    		가장 좋아했던 여자친구 이름은?
			    	</option>
			    	<option>
			    		가장 좋아했던 남자친구 이름은?
			    	</option>
			    </select><br>
			    <input type="text" class="form-control" id="findPwdAns" placeholder="질문의 정답을 입력해주세요." name="findPwdAns" autocomplete="off" required style="width:90%">
			    <div class="valid-feedback">Valid.</div>
			    <div class="invalid-feedback">Please fill out this field.</div>
			  </div>
			  <div class="form-groupd">
			  	<div id="captchaImg">
			  		<img src="../captchaImg/1650083349174.jpg"/>
			  	</div>
			  	<br>
			  	 <input type="text" class="form-control" id="imgAnswer" placeholder="이미지속 글자를 입력해주세요." name="imgAnswer" autocomplete="off" required style="width:90%">
			  </div>
			</form>
	      </div>
	
	      <!-- Modal footer -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" id="signUpBtn">가입하기</button>
	      </div>
	
	    </div>
	  </div> 
	</div>
	
	<!-- login modal -->
	<div class="modal fade" id="loginForm">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h4 class="modal-title">로그인</h4>
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	      </div>
	      <div class="modal-body">
	        <form>
			  <div class="form-group">
			    <!-- <label for="loginId">아이디:</label> -->
			    <input type="text" class="form-control" placeholder="Enter ID" id="loginId" autocomplete="off">
			  </div>
			  <div class="form-group">
			   <!--  <label for="loginPwd">비밀번호:</label> -->
			    <input type="password" class="form-control" placeholder="Enter PassWord" id="loginPwd" autocomplete="off">
			  </div>
			  <!-- <div class="form-group form-check"> -->
			    <label class="form-check-label">
			      <input class="form-check-input" type="checkbox"> ID 기억하기
			 <!--  </div> -->
			    </label><br>
			  <a class="btn btn-warning" data-toggle="modal" href="#findIdForm" id="findId">아이디 찾기</a>
			  <a class="btn btn-warning" data-toggle="modal" href="#findPwdForm" id="findPass" >비밀번호 찾기</a><br>
			  <button type="button" class="btn btn-primary" id="loginBtn">로그인</button>
			   <div class="hr-sect">또는</div>
			  <ul>			  
				<li onclick="kakaoLogin();">
			      <a href="javascript:void(0)">
			      	  <button type="button" id="kakaologin">
			      	  <span id="kakaologo">
			      	  <img src="../image/카카오.PNG" width="25px" height="25px" style="margin-left: 10px;">
			      	  </span>카카오로 로그인하기
			      	  </button>
			      </a>
				</li>
			  </ul>
				<button type="button" id="naverlogin">
			      	  <span id="kakaologo">
			      	  <img src="../image/btnG_아이콘사각.png" width="25px" height="25px" style="margin-left: 10px;">
			      	  </span>네이버로 로그인하기
			    </button>
				</form>
	      </div>
<!-- 	      <div class="modal-footer">
	        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
	      </div> -->
	
	    </div>
	  </div>
	</div>
	<!-- findId Modal -->
	<div class="modal fade" id="findIdForm" data-backdrop="static">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h4 class="modal-title">아이디 찾기</h4>
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	      </div>
	      <div class="modal-body">
	        <form action="">
			  <div class="form-group">
			    <label for="uname">이름</label>
			    <input type="text" class="form-control" placeholder="이름을 입력하세요" id="findIdname" autocomplete="off">
			  </div>
			  <div class="form-group">
			    <label for="tel">전화번호</label>
			    <input type="text" class="form-control" placeholder="전화번호를 입력하세요" id="findIdtel" autocomplete="off">
			  </div>
			  <div id="findIdResult">
			  </div>  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" id="findIdBtn">찾기</button>	
	      </div>
	
	    </div>
	  </div>
	</div>
	<!-- findPwd Modal -->
	<div class="modal fade" id="findPwdForm" data-backdrop="static">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h4 class="modal-title">비밀번호 찾기</h4>
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	      </div>
	      <div class="modal-body" id="findpassmo">
	        <form action="">
			  <div class="form-group">
			    <label for="findPassname">이름</label>
			    <input type="text" class="form-control" placeholder="이름을 입력하세요" id="findPassname" autocomplete="off">
			  </div>
			  <div class="form-group">
			    <label for="findPassid">아이디</label>
			    <input type="text" class="form-control" placeholder="아이디를 입력하세요" id="findPassid" autocomplete="off">
			  </div>
			   <div class="form-group">
			   <label for="findPasshint">힌트질문</label>
			 	   <select name="findPwd" id="findPasshint" style="width : 300px">
			   	 		<option>
			    			보물 1호는?
			    		</option>
			    		<option>
			    			졸업한 고등학교는?
			    		</option>
			   	 		<option>
			    			가장 좋아했던 여자친구 이름은?
			    		</option>
			    		<option>
			    			가장 좋아했던 남자친구 이름은?
			    		</option>
			  	    </select>
			     </div>
			  <div class="form-group">
			    <label for="findPassans">힌트정답</label>
			    <input type="text" class="form-control" placeholder="질문에 대한 정답을 입력하세요" id="findPassans" autocomplete="off">
			  </div>	  
			</form>
	      </div>
	      <div class="modal-footer">
	         <button type="button" class="btn btn-primary" id="findPwdBtn">확인</button>	
	      </div>
	
	    </div>
	  </div>
	</div>
	<div class="modal fade" id="newPassForm" data-backdrop="static">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h4 class="modal-title">비밀번호 변경</h4>
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	      </div>
	      <div class="modal-body" id="findpassmo">
	        <form action="">
			  <div class="form-group">
			    <label for="newpass">변경할 비밀번호</label>
			    <input type="password" class="form-control" placeholder="비밀번호를 입력하세요" id="newpass" autocomplete="off">
			  </div>	  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" id="getnewpass">변경하기</button>
	      </div>
	
	    </div>
	  </div>
	</div>
	
	<!-- The Modal -->
<div class="modal fade" id="qnaModal">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">어떠한 도움이 필요하신가요?</h4>
        <button type="button" class="close"  data-dismiss="modal">&times;</button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
			<span><%= cate %></span> <br> <br>
			<form action="">
				<div class="form-group">
					
					<input type="text" class="form-control" placeholder="질문할 제목을 입력해주세요." id="title" style="width:100%">
				</div>
				<div class="form-group">
					
					<textarea rows="5" cols="60" placeholder="질문할 내용을 입력해주세요." class="form-control" id="qcontest"></textarea>
				</div>
				
			</form>
		</div>

      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal" id="insert">추가</button>
      </div>

    </div>
  </div>
</div>

	<!-- The Modal -->
<div class="modal fade" id="qnaDetailModal">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title"><%= cate %> 관련 질문</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>

      <!-- Modal body -->
	<div class="modal-body">
		<form action="">
			<div class="form-group" id="qnaa">
				<label for="memId">작성자</label><br>
				<input type="text" class="form-control" id="memId" disabled style="width:100%; background:white; border-radius : 15px;"><br><br>
				<label for="date">작성날짜</label><br>
				<input type="text" class="form-control" id="date" disabled style="width:100%; background:white; border-radius : 15px;"><br><br>
				<label for="title">질문제목</label><br>
				<input type="text" class="form-control" id="qtitle" disabled style="width:100%; background:white; border-radius : 15px;"><br><br>
				<input type="hidden" class="form-control" id="qna_id" disabled>
				<label for="content">질문내용</label>
				
				<textarea rows="3" cols="60" class="form-control" id="content" disabled style="background:white; border-radius : 15px;"></textarea>
			</div>
		</form>
		<hr>
			<div id="accordion">

  <div class="card">
	   <div class="card-header" style="background: #FF385C; border-radius : 15px;">
	      <a class="card-link" data-toggle="collapse" href="#collapseOne" style="color:white;">
	        관리자 답변
	      </a>
	    </div>
	    <div id="collapseOne" class="collapse" data-parent="#accordion">
	      <div class="card-body">
	     
	      </div>
	    </div>
	  </div>
  </div>
     </div>
	<!-- Modal footer -->
 	<div class="modal-footer">
 	
	</div> 

    </div>
  </div>
</div>
</body>
</html>