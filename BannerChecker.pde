import java.io.File;

public class BannerChecker {

	// 2桁以上の数字
	static final String NUMREG = "[0-9][0-9][0-9]+";

	int number1 = 0;
	int number2 = 0;

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

	boolean isImage() {
		return img != null;
	}

	int getWidth() {
		return isImage() ? img.width : 0;
	}

	int getHeight() {
		return isImage() ? img.height : 0;
	}

	boolean getWidthResult() {
		return number1 == getWidth();
	}

	boolean getHeightResult() {
		return number2 == getHeight();
	}

	// 
	// PRIVATE
	// 

	private void readyImage() {
		img = loadImage(file.getAbsolutePath());
	}

	// ファイル名から数字を読み取る。読み取れなかった場合は0になる。
	private void detectNumbers() {
		String target = getNameWithoutExtension(file);
		String[][] mts = matchAll(target, NUMREG);
		
		if (mts != null) {
			if (mts[0] != null) number1 = stringToInt(mts[0][0]);
			if (mts[1] != null) number2 = stringToInt(mts[1][0]);
		}
	}

	private int stringToInt(String target) {
		return int(target);
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

	// 
	// TEST
	// 
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

}
