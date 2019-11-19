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

void setup()  {
  
  // てきとうにサイズ設定
  size(400, 300);
  
  // ==================================================
  // ファイルのドラッグ&ドロップをサポートするコード
  // ==================================================
  component = (Component)this.surface.getNative();
  
  //dropTarget = new DropTarget(this, new DropTargetListener() {
  dropTarget = new DropTarget(component, new DropTargetListener() {
    public void dragEnter(DropTargetDragEvent dtde) {}
    public void dragOver(DropTargetDragEvent dtde) {}
    public void dropActionChanged(DropTargetDragEvent dtde) {}
    public void dragExit(DropTargetEvent dte) {}
    public void drop(DropTargetDropEvent dtde) {
      dtde.acceptDrop(DnDConstants.ACTION_COPY_OR_MOVE);
      Transferable trans = dtde.getTransferable();
      List<File> fileNameList = null;
      if(trans.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
        try {
          fileNameList = (List<File>)
            trans.getTransferData(DataFlavor.javaFileListFlavor);
        } catch (UnsupportedFlavorException ex) {
          /* 例外処理 */
        } catch (IOException ex) {
          /* 例外処理 */
        }
      }
      if(fileNameList == null) return;
      // ドラッグ&ドロップされたファイルの一覧は一時リストに格納される
      // 以下のように書くと、ファイルのフルパスを表示
      for(File f : fileNameList) println(f.getAbsolutePath());
    }
  });
  // ==================================================
  
}

void draw() {
  /* 省略 */
}
