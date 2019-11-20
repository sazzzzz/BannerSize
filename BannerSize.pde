import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.dnd.*;
import java.awt.Component;
import java.io.File;
import java.io.IOException;
import java.util.List;

Component component;
DropTarget dropTarget;
List<File> files;
List<BannerChecker> checkers;
PFont font;

State state = State.INIT;
boolean dragOver = false;


void setup() {
	size(300, 300);
	createDropTarget();

	// font = createFont("Arial", 30);		// ローカルフォントを使う。重い。（最大サイズを決める）
	font = loadFont("Helvetica-14.vlw");	// 専用フォントを使う
	textFont(font);
	drawHere();
}

void draw() {

	if (dragOver) {
		background(#999999);
		drawHere();
	} else {
		background(#cccccc);
		switch (state) {
			case INIT:
				drawHere();
				break;
			case LOADING:
				drawLoading();
				break;
			case RESULT:
				drawResult();
				break;
		}
	}
}


private void drawHere() {
	fill(0);
	textSize(32);
	textAlign(CENTER);
	text("Drop Here", width/2, height/2);
}

private void drawLoading() {
	fill(0);
	textSize(32);
	textAlign(CENTER);
	text("loading...", width/2, height/2);
}

// draw result
private void drawResult() {
	if (!checkersExist()) return;
	
	final int ox = 8, oy = 20, lh = 20;
	final int x1 = ox, x2 = 240, x3 = 300-ox;

	// head
	fill(#666666);
	textSize(14);
	textAlign(LEFT);
	text("filename", x1, oy);
	textAlign(RIGHT);
	text("width", x2, oy);
	text("height", x3, oy);

	// body
	textSize(14);
	for(int i = 0, y = oy; i < checkers.size(); ++i){
		BannerChecker bc = checkers.get(i);
		if (!bc.isImage()) break;

		y += lh;

		// filename
		fill(0);
		textAlign(LEFT);
		text(bc.getFileName(), x1, y);
		// width
		fill(bc.getWidthResult() ? 0 : #cc0000);
		textAlign(RIGHT);
		text(bc.getWidth(), x2, y);
		// height
		fill(bc.getHeightResult() ? 0 : #cc0000);
		text(bc.getHeight(), x3, y);

		stroke(#999999);
		line(x1, y-15, width-ox, y-15);
	}
}

private boolean checkersExist() {
	return checkers != null && checkers.size() > 0;
}


private void checkFile(File file) {
	BannerChecker bc = new BannerChecker(file);
	bc.check();
	checkers.add(bc);
}

private void createDropTarget() {
	// ファイルのドラッグ&ドロップをサポート
	component = (Component)this.surface.getNative();
	dropTarget = new DropTarget(component, new DropTargetListener() {
		public void dragEnter(DropTargetDragEvent dtde) {
			print("enter");
			dragOver = true;
		}
		public void dragOver(DropTargetDragEvent dtde) {}
		public void dragExit(DropTargetEvent dte) {
			print("exit");
			dragOver = false;
		}

		public void dropActionChanged(DropTargetDragEvent dtde) {print("change");}
		public void drop(DropTargetDropEvent dtde) {
			dragOver = false;
			state = State.LOADING;
			dtde.acceptDrop(DnDConstants.ACTION_COPY_OR_MOVE);
			Transferable trans = dtde.getTransferable();
			files = null;
			checkers = null;

			if (trans.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
				try {
					files = (List<File>)
						trans.getTransferData(DataFlavor.javaFileListFlavor);
				} catch (UnsupportedFlavorException ex) {	/* 例外処理 */
				} catch (IOException ex) {					/* 例外処理 */
				}
			}

			// ファイルがあったらチェック開始
			if (files != null) {
				checkers = new ArrayList<BannerChecker>();
				for (File f : files) checkFile(f);
				updateState();
			}
		}
	});
}

private void updateState() {
	if (checkersExist()) {
		state = State.RESULT;
	} else {
		state = State.INIT;
	}
}
