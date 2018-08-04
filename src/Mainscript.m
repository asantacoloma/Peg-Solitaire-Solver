clear
clc

tic

FIDA = input('what image number do you want to check?', 's');
FIDB = '.png';
FID = [FIDA FIDB];
[ Triangle ] = AnalyzePegImage( FID );

disp('Initial board layout is')
disp(Triangle)

[ Solutions , WinningPaths ] = PegAlgorithm( Triangle );
fprintf('Total number of solutions is %d! \n',Solutions)

WinningPaths;

toc