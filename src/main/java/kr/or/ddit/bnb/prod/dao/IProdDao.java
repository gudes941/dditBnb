package kr.or.ddit.bnb.prod.dao;

import java.sql.SQLException;
import java.util.List;

import com.ibatis.sqlmap.client.SqlMapClient;

import kr.or.ddit.bnb.member.vo.FavorListVO;
import kr.or.ddit.bnb.prod.vo.ProdConvenVO;
import kr.or.ddit.bnb.prod.vo.ProdImgVO;
import kr.or.ddit.bnb.prod.vo.ProdVO;
import kr.or.ddit.bnb.prod.vo.ReviewVO;

public interface IProdDao {
	
	//상품숙소 등록
	public int insertProd(SqlMapClient smc,ProdVO prodVo) throws SQLException;
	
	//이미지 등록 
	public int insertProdImg(SqlMapClient smc,ProdImgVO prodimgVo)throws SQLException;
	
    //편의시설 등록 
    public int insertProdConven(SqlMapClient smc,ProdConvenVO prodconvenVo)throws SQLException;
    
    //상품리뷰 등록
  	public int insertRev(SqlMapClient smc, ReviewVO revVo) throws SQLException;
  	
  	//상품리뷰 수정
  	public int updateRev(SqlMapClient smc, ReviewVO revVo) throws SQLException;
  	
  	//상품리뷰 삭제
  	public int deleteRev(SqlMapClient smc, String review_id) throws SQLException;
  	
  	//상품리뷰 조회
  	public List<ReviewVO> selectRev(SqlMapClient smc, String prod_id) throws SQLException;
  	
  //숙소등록삭제 상태 변경 n을 y로 변경
	
  	public int updateProd(SqlMapClient smc,ProdVO prodVo)throws SQLException;
        
  	//호스트가 등록한 숙소 목록
  	public List<ProdVO> HostProdList(SqlMapClient smc, String memId) throws SQLException;
}
