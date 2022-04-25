/*강의평가와 관련된 db접근 직접적으로 가능하게 해주는 객체*/
package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DatabaseUtil;

public class EvaluationDAO {

	/*로그인 시도*/
	public int write(EvaluationDTO evaluationDTO) {		//사용자가 강의 정보를 기록할 수 있도록 해줌
		String SQL = "INSERT INTO EVALUATION VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, evaluationDTO.getUserID());
			pstmt.setString(2, evaluationDTO.getLectureName());
			pstmt.setString(3, evaluationDTO.getProfessorName());
			pstmt.setInt(4, evaluationDTO.getLectureYear());
			pstmt.setString(5, evaluationDTO.getSemesterDivide());
			pstmt.setString(6, evaluationDTO.getLectureDivide());
			pstmt.setString(7, evaluationDTO.getEvaluationTitle());
			pstmt.setString(8, evaluationDTO.getEvaluationContent());
			pstmt.setString(9, evaluationDTO.getTotalScore());
			pstmt.setString(10, evaluationDTO.getCreditScore());
			pstmt.setString(11, evaluationDTO.getComfortableScore());
			pstmt.setString(12, evaluationDTO.getLectureScore());
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();		
		} finally {	//접근한 자원 해제
			try {if(conn != null) conn.close();} catch(Exception e) {e.printStackTrace();}
			try {if(pstmt != null) pstmt.close();} catch(Exception e) {e.printStackTrace();}
			try {if(rs != null) rs.close();} catch(Exception e) {e.printStackTrace();}
		}
		return -1;	//데이터베이스 오류
	}
}
