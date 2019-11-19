import java.io.File;

public class BannerChecker {

	// 2桁以上の数字
	static final String NUMREG = "[0-9][0-9][0-9]+";

	int number1 = -1;
	int number2 = -1;

	File file;
	PImage img;

	public BannerChecker(File bnrFile) {
		file = bnrFile;
	}

	// 
	// PUBLIC
	// 

	void check() {
		//ファイルの存在確認
		if (file != null && file.exists()) {
			detectNumbers();
			readyImage();
		}
	}

	String getFileName() {
		return file.getName();
	}

	int getWidth() {
		return img.width;
	}

	int getHeight() {
		return img.height;
	}

	boolean getWidthResult() {
		return number1 == img.width;
	}

	boolean getHeightResult() {
		return number2 == img.height;
	}

	// 
	// PRIVATE
	// 

	private void readyImage() {
		img = loadImage(file.getAbsolutePath());
		// println(img.width+"X"+img.height);
	}

	private void detectNumbers() {
		String target = getNameWithoutExtension(file);
		String[][] mts = matchAll(target, NUMREG);
		number1 = stringToInt(mts[0][0]);
		number2 = stringToInt(mts[1][0]);
		// println(target);
		// println(number1+","+number2);
	}

	private int stringToInt(String target) {
		return int(target);
	}

	private void testMatch() {
		String target = getNameWithoutExtension(file);
		println(file.getName());
		String[][] mts = matchAll(target, NUMREG);
		for (int i = 0; i < mts.length; i++) {
			String res = "";
			for (int j = 0; j < mts[i].length; j++) {
				res += mts[i][j]+",";
			}
			println(i+": "+res);
		}
	}


	private String getNameWithoutExtension(File file)
	{
		String fileName = file.getName();
		int index = fileName.lastIndexOf('.');
		if (index != -1)
		{
			return fileName.substring(0, index);
		}
		return "";
	}
}
