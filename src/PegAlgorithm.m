function [ Solutions , WinningPaths ] = PegAlgorithm( Triangle )

%Detailed explanation goes here
% Given a vector of peg positions, return a 2D vector of all possible solutions



%List of possible jumps in the game ordered by what start peg is, 
% i.e. First row has moves that start with spot one and so on.
% ellipses (aka: ...) are used for organiztional and aesthetic purposes

Jumps=[ 1 3 6; 1 2 4; ...
    2 4 7; 2 5 9; ...
    3 6 10; 3 5 8; ...
    4 2 1; 4 5 6; 4 7 11; 4 8 13; ...
    5 8 12; 5 9 14; ...
    6 3 1; 6 5 4; 6 10 15; 6 9 13; ...
    7 4 2; 7 8 9; ...
    8 5 3; 8 9 10; ...
    9 5 2; 9 8 7; ...
    10 9 8; 10 6 3; ...
    11 7 4; 11 12 13; ...
    12 8 5; 12 13 14; ...
    13 8 4; 13 9 6; 13 12 11; 13 14 15; ...
    14 13 12; 14 9 5; ...
    15 14 13; 15 10 6];

%Initial Parent ID
ParentID=0;

%exploreList initial index, index is used to specify rows of explorelist
%and what move is stored in explorelist. Ex: index= 3 move 3 is stored in third row of explorelist 
index=1;

% Preallocation of exploreList in order to lessen processing time. 
% explore list has 19 columns, 
%column 1: parent ID
% Column 2:4 is what pegs were used in jump, in order of start, middle, end
% Columns 5:19 are used to store board layout for the specific move
% total is used to store current number of moves in order to 
% avoid overwriting already used rows when putting data into exploreList

exploreList=zeros(4000000,19);

%loop below is used to find first set of possible moves at the start of the
%board
%numofmoves is the number of possible moves to choose from in current board

numofmoves=0;
moveList=[];

%disps are used to see current progress of program with the board

disp('working on first loop')

%Loop checks to see which of the 36 legal moves in the game can be done
%with current board layout and stores possible moves into exploreList

for ii=1:36
    start=Jumps(ii,1);
    middle=Jumps(ii,2);
    eend=Jumps(ii,3);
    if Triangle(start)==1 && Triangle(middle)==1 && Triangle(eend)==0
            
        %newboard is the modified board if the move is made
        
        newboard= Triangle;
        newboard(start)=0;
        newboard(middle)=0;
        newboard(eend)=1;
        numofmoves=numofmoves+1;
        
        % moveList stores parent, move data, and modified board
        moveList=[moveList; ParentID start middle eend newboard];
    end
end


total=numofmoves;
exploreList(1:numofmoves,:)=[moveList];



%second loop is similar to first but uses board values already stored in
%exploreList

disp('Working on second loop')

while index <= total
    
    ParentID = index;
    
    CurrentBoard = exploreList(index,5:19);
    
   
   numofmoves = 0;
moveList = [];

 
%Loop checks to see which of the 36 legal moves in the game can be done
%with current board layout

for ii = 1:36
    start = Jumps(ii,1);
    middle = Jumps(ii,2);
    eend = Jumps(ii,3);
    if CurrentBoard(start) == 1 && CurrentBoard(middle) == 1 && CurrentBoard(eend) == 0
            
        %newboard is the modified board if the move is made
        
        newboard = CurrentBoard;
        newboard(start) = 0;
        newboard(middle) = 0;
        newboard(eend) = 1;
        numofmoves = numofmoves + 1;
        
        % moveList stores parent, move data, and modified board
        moveList = [moveList;ParentID start middle eend newboard];
    end
end
 
    
    if numofmoves >= 1
       total = total + numofmoves ;
        exploreList(total + 1 - numofmoves:total,:) = moveList;
    end
    index = index + 1;
    
end

% Eliminates empty spots in explorelist
exploreList = exploreList(1:total,:);

%solutions counter
Solutions = 0;

%Preallocation for solved paths in order to lessen processing time
WinningPaths = zeros(100000,30);

%loop used to check exploreList for rows with boards containing only 1 peg
disp('organizing data')

for ii = total:-1:1
    if sum(exploreList(ii,5:19)) == 1
Solutions = Solutions + 1;
Solutionblock = ones(15,4);
Solutionblock(1,:) = exploreList(ii,1:4);

% Solutionblock is a variable used to temporarily store sections of data
% extracted from exploreList

% Solutionblock is used to handle smaller portions of explorelist and
% backtrack explorelist to create a single solution path
% Path in Solutionblock is backwards, it is flipped using flip function and
% is then stored into a single row in WinningPaths matrix.
%once data from Solutionblock is copied to WinningPaths, solutionblocks is
%reset and is overwritten with next path data
% NextPID is Next parent ID

move = 1;
NextPID =  exploreList(ii,1);
while Solutionblock(move,1) ~= 0   
    move = move + 1;
Solutionblock(move,:) = exploreList(NextPID,1:4);
NextPID = Solutionblock(move,1);

Solutionblock = Solutionblock(1:move,:);
end

Solutionblock = flip(Solutionblock);
for jj = 2:2:(move*2)
    
    
WinningPaths(Solutions,jj-1:jj) = Solutionblock(jj/2,2:2:4);

    end
    end
end



%removes empty rows from WinningPaths

WinningPaths = WinningPaths(1:Solutions,1:move*2);


end