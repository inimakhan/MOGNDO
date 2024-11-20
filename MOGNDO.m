
%__________________________________________________________________     %
% Multi-objective Generalized Normal Distribution Optimization (MOGNDO) %
%          A Novel Algorithm for Multi-objective Problems               %
%                                                                       %
%                                                                       %
%                  Developed in MATLAB R2023a (MacOs)                   %
%                                                                       %
%                      Author and programmer                            %
%                ---------------------------------                      %
%                Nima Khodadadi (ʘ‿ʘ)   University of Miami             %
%                         SeyedAli Mirjalili                            %
%                             e-Mail                                    %
%                ---------------------------------                      %
%                      Nima.khodadadi@miami.edu                         %
%                                                                       %
%                                                                       %
%                            Homepage                                   %
%                ---------------------------------                      %
%                    https://nimakhodadadi.com                          %
%                                                                       %
%                                                                       %
%                                                                       %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %


function [Archive_costs]=MOGNDO(MaxIt,Archive_size,GNDO_num,nVar,method,m)
%% Problem Definition
if method==3
    TestProblem=sprintf('P%d',m);
    fobj = Ptest(TestProblem);
    xrange  = xboundaryP(TestProblem);
    nVar=max(size(xrange));
    % Lower bound and upper bound
    lb=xrange(:,1)';
    ub=xrange(:,2)';
end


%% MOGNDO Parameters
alpha=0.01;  % Grid Inflation Parameter
nGrid=30;   % Number of Grids per each Dimension
Beta=4;     % Leader Selection Pressure Parameter
gamma=2;    % Extra (to be deleted) Repository Member Selection Pressure

%% Initialise the population
GNDO=CreateEmptyParticle(GNDO_num);
for i=1:GNDO_num
    GNDO(i).Velocity=0;
    GNDO(i).Position=zeros(1,nVar);
    for j=1:nVar
        GNDO(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
    end
    GNDO(i).Cost=fobj(GNDO(i).Position')';
    GNDO(i).Best.Position=GNDO(i).Position;
    GNDO(i).Best.Cost=GNDO(i).Cost;
end
GNDO=DetermineDominations(GNDO);
Archive=GetNonDominatedParticles(GNDO);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);
for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
for it=1: 1 : MaxIt
    for i=1:GNDO_num
        Leader=SelectLeader(Archive,Beta);
        GNDO(i).Cost= fobj(GNDO(i).Position')';
        if GNDO(i).Cost < GNDO(i).Best.Cost
            GNDO(i).Best.Position = GNDO(i).Position;
        end
    end
    mo=mean(Leader.Position');
    for i=1:GNDO_num
        a=randperm(GNDO_num,1);
        b=randperm(GNDO_num,1);
        c=randperm(GNDO_num,1);
        while a==i | a==b | c==b | c==a |c==i |b==i
            a=randperm(GNDO_num,1);
            b=randperm(GNDO_num,1);
            c=randperm(GNDO_num,1);
        end

        if GNDO(a).Cost<GNDO(i).Cost
            v1=GNDO(a).Position-GNDO(i).Position;
        else
            v1=GNDO(i).Position-GNDO(a).Position;
        end

        if GNDO(b).Cost<GNDO(c).Cost
            v2=GNDO(b).Position-GNDO(c).Position;
        else
            v2=GNDO(c).Position-GNDO(b).Position;
        end

        if rand<=rand

            u=1/3*(GNDO(i).Position+Leader.Position+mo);
            deta=sqrt(1/3*((GNDO(i).Position-u).^2 ...
                +(Leader.Position-u).^2+(mo-u).^2));
            vc1=rand(1,nVar);
            vc2=rand(1,nVar);
            Z1=sqrt(-1*log(vc2)).*cos(2*pi.*vc1);
            Z2=sqrt(-1*log(vc2)).*cos((2*pi.*vc1)+pi);
            a = rand;
            b = rand;
            if a<=b
                eta = (u+deta.*Z1);
            else
                eta = (u+deta.*Z2);
            end
            GNDO(i).Position= eta;
        else
            beta=rand;
            v = GNDO(i).Position+Leader.Position +beta*abs(randn).*v1 ...
                +(1-beta)*abs(randn).*v2;
            GNDO(i).Position = v;
        end
        GNDO(i).Position=min(max(GNDO(i).Position,lb),ub);
        GNDO(i).Cost=fobj(GNDO(i).Position')';
    end
    GNDO=DetermineDominations(GNDO);
    non_dominated_GNDO=GetNonDominatedParticles(GNDO);
    Archive=[Archive
        non_dominated_GNDO];
    Archive=DetermineDominations(Archive);
    Archive=GetNonDominatedParticles(Archive);
    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end
    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);
        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);
    end
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    costs=GetCosts(GNDO);
    Archive_costs=GetCosts(Archive);
end

end


