%how many cells are complete? 
dims=size(cells);
M=[];
for n=1:dims(1,2)
    for i=1:dims(1,1)
        x=isempty(cells{i,n});
        M(i,n)=int8(x);
    end 
end 
M(:,n+1)=sum(M');
nbins = [0:1:n];
[binranges]=hist(double(M(:,n+1)),nbins);
[tf,loc]=find(double(M(:,n+1)<6)); %index all cells that have more than 1 day

%%
%zscore each cell 
for i=1:numel(cells)
    cells{i}=zscore(cells{i});
end 
%%
f=figure (6);
f.Position=[1,1,1000,100];
vl((1:2),1)=85;
hl=(0:1);
idx=tf%(1:10,:);%subslelect cells that have more than 1 day 
%idx=[29 43 47 56 62 85 89];
for n=1:24
    subplot (6,4,n)
    plot(vl,hl,'k','lineWidth',0.5)
        hold on
        for i=[1 2 3 4 5 6 7] %7 is the number of recordings 
        nn=n;%(idx(n));%change here which cells should be plotted
            if isempty (cells{nn,i})
            continue 
            else
        
        x=cells{nn,i};
        fluo=movmean(mean(x'),10);
        %err=movmean(std(x'),10);
        err=movmean((std(x')/sqrt(length(x'))),10);
        shadedErrorBar([],fluo,err,'lineprops', {'color',co(i,:) })       
        ylim([-0.5 inf])
        xlim([50 150])
        title(nn)
        box off
        end 
        end 
       
end 

%% makes 2 matrices in the shape of cells: bsl is the baseline mean fluorescence and stim is the mean respose 
dims=size(cells);
for n=1:dims(1,2)
    for i=1:dims(1,1)
        if isempty (cells{i,n})
          bsl{i,n}=NaN; 
          stim{i,n}=NaN;
          else
    bsl{i,n}=mean(cells{i,n}(1:50,:));
    stim{i,n}=mean(cells{i,n}(85:105,:));
        end
    end 
end 