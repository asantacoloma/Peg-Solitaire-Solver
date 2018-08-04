function [ Triangle ] = AnalyzePegImage( FID )

%Given the name of an image, determine the positions of the pegs on the
%board



pixels = imread(FID);



[rows, cols, colors] = size(pixels);
binary = false(rows ,cols) ;
for ii = 1 : rows
    for jj = 1 : cols
        if pixels(ii,jj,3) < pixels(ii,jj,2) && pixels(ii,jj,3) < pixels(ii,jj,1)
            binary(ii,jj,:) = 1;
        end
    end
end


% binary image of triangle
[Brows, Bcols, Bcolors] = size(binary);

count = 1;

for kk = 1:Brows
    for ll = 1: Bcols
        
   if count > 1 
           break
   end  
 
   if binary(kk,ll,:) == 1
       
 
%  xref = ll
%  yref = kk
RefA = [ll , kk];
count = 2;
     
       end
    end
    end       

   



% height = checks of number of rows with a white/true pixel

for mm = 1: Bcols
    
    for nn = Brows: -1: 1
   if count > 2 
        break
   end
   if binary(nn,mm,:) == 1
        RefB = [mm , nn];
        count = count + 1;
    end
    end
end
RefB;
Height = RefB(2)-RefA(2);

%Triangle in image 10 is used as a reference triangle
%ysteps are 107 pixels for img10
%xsteps are 60 pixels for img 10
%ysteps are named drops
%xsteps are named slides
%Height of triangle in image 10 is 527 pixels
%spot 1 is 60 pixels down from refA, and no movement in x direction




% peg spots and check if filled
% store spots into a vector
%Triangle is variable used to store board layout

Triangle = zeros(1,15);

DropRatio = (107/527);
SlideRatio = (60/527);

drop = round(DropRatio*Height);
slide = round((SlideRatio*Height));


%list of every spot and their distances from reference point
%spot one uses top corner (stored as RefA) for reference point
spot1 = [RefA(1),RefA(2)+round(0.5*drop)];

%spots 2-15 use x and y coordinates of spot1 as reference point

spot2 = [spot1(1)-1*slide,spot1(2)+drop];
spot3 = [spot1(1)+1*slide,spot1(2)+drop];
spot4 = [spot1(1)-2*slide,spot1(2)+2*drop];
spot5 = [spot1(1)-0*slide,spot1(2)+2*drop];
spot6 = [spot1(1)+2*slide,spot1(2)+2*drop];
spot7 = [spot1(1)-3*slide,spot1(2)+3*drop];
spot8 = [spot1(1)-1*slide,spot1(2)+3*drop];
spot9 = [spot1(1)+1*slide,spot1(2)+3*drop];
spot10 = [spot1(1)+3*slide,spot1(2)+3*drop];
spot11 = [spot1(1)-4*slide,spot1(2)+4*drop];
spot12 = [spot1(1)-2*slide,spot1(2)+4*drop];
spot13 = [spot1(1)-0*slide,spot1(2)+4*drop];
spot14 = [spot1(1)+2*slide,spot1(2)+4*drop];
spot15 = [spot1(1)+4*slide,spot1(2)+4*drop];

%store spot locations in one large matrix
Peg = cat(1,spot1,spot2,spot3,spot4,spot5,spot6,spot7,spot8,spot9,...
    spot10,spot11,spot12,spot13,spot14,spot15);

%switch rows & cols due to image x and y coordinates being related to
%columns and rows respectively

for qq = 1:15
    Peg(qq,[2 1] )= Peg(qq,[1 2]) ;


end


%check the 15 spots on the board for pegs
for pp = 1:15
    Memory = (Peg(pp,:));
    
    for qq = Memory(2)-15 : Memory(2)+15
        
    if binary(Memory(1),qq) == 0
        
    Triangle(pp) = 1;
    end
    end
    end

for pp = 1:15
    Memory = (Peg(pp,:));
    
    for qq = Memory(2)-15 : Memory(2)+10
        for rr = Memory(1)-10 : Memory(1)+10
    if binary(rr,Memory(2)) == 0
        
    Triangle(pp) = 1;
    end
    end
    end
end

  Triangle;
  
  %Code created to make testing and debugging of function easier 
    %Solution tester code
%     if strcmp(FID,'01.png') 
%         Test = [0 0 0 1 1 0 0 1 1 0 0 0 0 0 0];
%         
%     elseif strcmp(FID,'02.png')
%         Test = [0 0 0 1 1 0 0 1 1 0 0 0 0 1 1];
%         
%         elseif strcmp(FID,'03.png')
%         Test = [0 0 0 0 0 1 0 1 1 0 0 0 0 1 0];
%         
%             elseif strcmp(FID,'04.png')
%         Test = [0 0 0 1 0 1 0 1 1 0 0 0 0 1 0];
%         
%             elseif strcmp(FID,'05.png')
%         Test = [1 1 1 1 1 0 0 1 1 0 1 0 0 1 0];
%         
%     elseif strcmp(FID,'06.png')
%         Test = [0 1 1 0 1 0 1 1 1 1 1 1 0 1 1];
%         
%             elseif strcmp(FID,'07.png')
%         Test = [0 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%         
%     elseif strcmp(FID,'08.png') 
%         Test = [1 1 1 1 0 1 1 1 1 1 1 1 1 1 1];
%         
%             elseif strcmp(FID,'09.png') 
%         Test = [1 1 1 1 1 1 1 1 1 1 1 0 1 1 1];
%         
%     elseif strcmp(FID,'10.png')
%         Test = [1 1 1 0 1 1 1 1 1 1 1 1 1 1 1];
%     else 
%         Test = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
%     end
%             
% if isequal(Test,Triangle) == 1
%     disp('no problems found')
% else
%     disp('something''s wrong')
% end




end

