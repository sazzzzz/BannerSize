import java.io.File;

public class BannerChecker {

	// 2桁以上の数字
	static final String NUMREG = "[0-9][0-9]+";

	int number1 = -1;
	int number2 = -1;
	

	File file;
	PImage img;

	public BannerChecker(File bnrFile) {
		file = bnrFile;
		check();
	}

	void check() {
		// println(file.getAbsolutePath());
		// println(file.getName());

		detectNumbers();
		// loadImg();
	}

	void loadImg() {
		img = loadImage(file.getAbsolutePath());
		println(img.width+"X"+img.height);
	}

	void detectNumbers() {
		String target = getNameWithoutExtension(file);
		String[][] mts = matchAll(target, NUMREG);
		number1 = stringToInt(mts[0][0]);
		number2 = stringToInt(mts[1][0]);

		println(target);
		println(number1+","+number2);
	}

	int stringToInt(String target) {
		return int(target);
	}

	void testMatch() {
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


	String getNameWithoutExtension(File file)
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
