package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator{  //인증 수행 도와주는 클래스
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("dikapeulio912@gmail.com", "dika912912");
	}

}
