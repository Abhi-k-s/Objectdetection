filename = 'library.mp4';
hVideoSrc = VideoReader(filename);
hBlob = vision.BlobAnalysis( ...
            'AreaOutputPort', false, ...
            'BoundingBoxOutputPort', false, ...
            'OutputDataType', 'single');
hVideoOut = vision.VideoPlayer('Name', 'Object counter');
hVideoOut.Position(3:4) = [960 350];

while hasFrame(hVideoSrc)
    I = im2gray(readFrame(hVideoSrc)); 
    Im = imtophat(I, strel('square',579 ));
    
    Im = imopen(Im, strel('rectangle',[960 50]));
   
    th = multithresh(Im); 
    BW = Im > th;
    
    Centroids = step(hBlob, BW);              
    
    BooksCount = int32(size(Centroids,1));  
    txt = sprintf('Book count: %d', BooksCount);
    It = insertText(I,[10 280],txt,'FontSize',22);
             
    Centroids(:, 2) = Centroids(1,2);            

    It = insertMarker(It, Centroids, 'o', 'Size', 6, 'Color', 'r');
    It = insertMarker(It, Centroids, 'o', 'Size', 5, 'Color', 'r');
    It = insertMarker(It, Centroids, '+', 'Size', 5, 'Color', 'r');
    
    step(hVideoOut, It);
end