package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator{  //���� ���� �����ִ� Ŭ����
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("dikapeulio912@gmail.com", "dika912912");
	}

}
