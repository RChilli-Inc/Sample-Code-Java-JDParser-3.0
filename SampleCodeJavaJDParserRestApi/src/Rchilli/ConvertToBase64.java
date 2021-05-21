package Rchilli;

import java.io.File;
import java.io.FileInputStream;

import org.apache.commons.codec.binary.Base64;

public class ConvertToBase64 {
	public String Convert(String filePath)
	{
		try
		{
		 File f = new File(filePath);
         FileInputStream fin = new FileInputStream(f);
         byte[] fileContent = new byte[(int) f.length()];
         fin.read(fileContent);
         byte[] encoded = Base64.encodeBase64(fileContent);     
        String encodedString =new String(encoded);
        fin.close();
        
        return encodedString ;
		}
		catch(Exception ex)
		{
			return "Error:- "+ex.getMessage();
		}
	}

}
