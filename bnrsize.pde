import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.dnd.*;
import java.awt.Component;
import java.io.File;
import java.io.IOException;
import java.util.List;

DropTarget dropTarget;
Component component;
List<File> files;
List<BannerChecker> checkers;
// BannerChecker[] checkers;
PFont font;
boolean checkerState = false;

void setup()  {
	// てきとうにサイズ設定
	size(300, 256);
	noSmooth();
	createDropTarget();

	// font = createFont("Arial", 30);  //この際に最大サイズを決める
	font = loadFont("Helvetica-48.vlw");
	textFont(font);  //設定したフォントを使用
	
	textSize(30);  //サイズを最終決定
	fill(0);  //色を決定
	text("OK", 20, height/3);
}

void draw() {
	if (!checkerState || checkers == null || checkers.size() == 0) return;

	background(#cccccc);

	int ox = 8, oy = 16;
	int x1 = ox, x2 = 200, x3 = 250;

	// head
	fill(#666666);
	textSize(12);
	text("filename", x1, oy);
	text("width", x2, oy);
	text("height", x3, oy);

	fill(0);
	textSize(14);
	for(int i = 0; i < checkers.size(); ++i){
		BannerChecker bc = checkers.get(i);
		int y = oy * 2 + i * 16;

		// filename
		fill(0);
		text(bc.getFileName(), x1, y);
		// width
		fill(bc.getWidthResult() ? 0 : #cc0000);
		text(bc.getWidth(), x2, y);
		// height
		fill(bc.getHeightResult() ? 0 : #cc0000);
		text(bc.getHeight(), x3, y);
	}
}


void checkFile(File file) {
	// println(file.getAbsolutePath());
	BannerChecker bc = new BannerChecker(file);
	checkers.add(bc);
	bc.check();

	println(bc.getWidthResult()+","+bc.getHeightResult());
}

void createDropTarget() {
	// ファイルのドラッグ&ドロップをサポート
	component = (Component)this.surface.getNative();
	dropTarget = new DropTarget(component, new DropTargetListener() {
		public void dragEnter(DropTargetDragEvent dtde) {}
		public void dragOver(DropTargetDragEvent dtde) {}
		public void dropActionChanged(DropTargetDragEvent dtde) {}
		public void dragExit(DropTargetEvent dte) {}
		public void drop(DropTargetDropEvent dtde) {
			checkerState = false;

			dtde.acceptDrop(DnDConstants.ACTION_COPY_OR_MOVE);
			Transferable trans = dtde.getTransferable();
			files = null;
			checkers = null;

			if(trans.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
				try {
					files = (List<File>)
					trans.getTransferData(DataFlavor.javaFileListFlavor);
				} catch (UnsupportedFlavorException ex) {
					/* 例外処理 */
				} catch (IOException ex) {
					/* 例外処理 */
				}
			}
			if(files == null) return;

			checkers = new ArrayList<BannerChecker>();
			// checkers = new BannerChecker[files.size];
			for(File f : files) checkFile(f);

			checkerState = true;
		}
	});
}

