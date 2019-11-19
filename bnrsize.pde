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
PFont font;

void setup()  {
	size(300, 300);
	createDropTarget();

	// font = createFont("Arial", 30);		//この際に最大サイズを決める
	font = loadFont("Helvetica-14.vlw");
	textFont(font);							//設定したフォントを使用
	
	textSize(32);							//サイズを最終決定
	fill(0);								//色を決定
	text("Drop Images", 20, height/3);
}

void draw() {
	background(#cccccc);
	if (checkersExist()) drawResult();
}


// draw result
private void drawResult() {
	if (!checkersExist()) return;
	
	final int ox = 8, oy = 20, lh = 20;
	final int x1 = ox, x2 = 200, x3 = 250;

	// head
	fill(#666666);
	textSize(14);
	text("filename", x1, oy);
	text("width", x2, oy);
	text("height", x3, oy);

	// body
	fill(0);
	textSize(14);
	int y = oy;
	for(int i = 0; i < checkers.size(); ++i){
		BannerChecker bc = checkers.get(i);

		if (bc.isImage()) {
			y += lh;

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
}

private boolean checkersExist() {
	return checkers != null && checkers.size() > 0;
}


private void checkFile(File file) {
	BannerChecker bc = new BannerChecker(file);
	checkers.add(bc);
	bc.check();
}

private void createDropTarget() {
	// ファイルのドラッグ&ドロップをサポート
	component = (Component)this.surface.getNative();
	dropTarget = new DropTarget(component, new DropTargetListener() {
		public void dragEnter(DropTargetDragEvent dtde) {}
		public void dragOver(DropTargetDragEvent dtde) {}
		public void dropActionChanged(DropTargetDragEvent dtde) {}
		public void dragExit(DropTargetEvent dte) {}
		public void drop(DropTargetDropEvent dtde) {
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
		}
	});
}

