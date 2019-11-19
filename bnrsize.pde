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
List<BannerChecker> chekers;

void setup()  {

	// てきとうにサイズ設定
	size(256, 256);

	createDropTarget();

}

void draw() {
	/* 省略 */
}


void createDropTarget() {
	// ファイルのドラッグ&ドロップをサポートするコード
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
				// ドラッグ&ドロップされたファイルの一覧は一時リストに格納される
				// 以下のように書くと、ファイルのフルパスを表示
				//   for(File f : files) println(f.getAbsolutePath());

			chekers = new ArrayList<BannerChecker>();
			for(File f : files) checkFile(f);
		}
	});
}

void checkFile(File file) {
	// println(file.getAbsolutePath());
	BannerChecker bc = new BannerChecker(file);
	chekers.add(bc);
	bc.check();
}

