package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	/*�������� �� connection��ü�� �̿��ؼ� DB�� ������ ���¸� ����*/
	public static Connection getConnection() {	//������ ���� ��ü�� ��ȯ
		try {	//try ~ catch���� ���� �߻� �� ���� ó���ϱ� ���� ���
			String dbURL = "jdbc:mysql://localhost:3306/LectureEvaluation";	//mysql�� ����
			String dbID = "root";	//�ְ� ������ ID
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");	//�ش� Ŭ���� ã�Ƽ� ������ְڴٴ� ����
			return DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;	//���� �߻� �� null�� ��ȯ
	}
}
