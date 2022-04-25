package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	/*연동했을 때 connection객체를 이용해서 DB와 연동된 상태를 관리*/
	public static Connection getConnection() {	//접속한 상태 자체를 반환
		try {	//try ~ catch문은 오류 발생 시 쉽게 처리하기 위해 사용
			String dbURL = "jdbc:mysql://localhost:3306/LectureEvaluation";	//mysql에 접속
			String dbID = "root";	//최고 권한의 ID
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");	//해당 클래스 찾아서 사용해주겠다는 정의
			return DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;	//오류 발생 시 null값 반환
	}
}
