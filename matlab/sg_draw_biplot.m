function [coeff,score,latent,tsquared,explained,mu] = sg_draw_biplot(data,data_name,fig_num,fig_size,fig_filename,data_colorid)
%SG_DRAW_BIPLOT Summary of this function goes here
%   Detailed explanation goes here
%
%   AUTHORS:
%   Rene Labounek (1), Julien Cohen-Adad (2), Christophe Lenglet (3), Igor Nestrasil (1,3)
%   email: rlaboune@umn.edu
%
%   INSTITUTIONS:
%   (1) Masonic Institute for the Developing Brain, Division of Clinical Behavioral Neuroscience, Deparmtnet of Pediatrics, University of Minnesota, Minneapolis, Minnesota, USA
%   (2) NeuroPoly Lab, Institute of Biomedical Engineering, Polytechnique Montreal, Montreal, Quebec, Canada
%   (3) Center for Magnetic Resonance Research, Department of Radiology, University of Minnesota, Minneapolis, Minnesota, USA

    data_mean = mean(data,'omitnan');
    data_std = std(data,'omitnan');
    data = ( data - repmat(data_mean,size(data,1),1) ) ./ repmat(data_std,size(data,1),1);
    [coeff,score,latent,tsquared,explained,mu] = pca(data);

    for ind = 1:size(data_name,2)
        brk_pos=find(data_name{1,ind}=='[');
        data_name{1,ind} = data_name{1,ind}(1:brk_pos-2);
    end

    h.fig = figure(fig_num);
    set(h.fig, 'Position', fig_size);

    subplot(2,2,1)
    cmp1=1;cmp2=2;
    bp=biplot(coeff(:,[cmp1 cmp2]),'VarLabels',data_name,'LineWidth',3,'MarkerSize',30);
    sg_mod_biplot(bp,explained,cmp1,cmp2,data_colorid)

    subplot(2,2,2)
    cmp1=1;cmp2=3;
    bp=biplot(coeff(:,[cmp1 cmp2]),'VarLabels',data_name,'LineWidth',3,'MarkerSize',30);
    sg_mod_biplot(bp,explained,cmp1,cmp2,data_colorid)

    subplot(2,2,3)
    cmp1=1;cmp2=4;
    bp=biplot(coeff(:,[cmp1 cmp2]),'VarLabels',data_name,'LineWidth',3,'MarkerSize',30);
    sg_mod_biplot(bp,explained,cmp1,cmp2,data_colorid)

    subplot(2,2,4)
    cmp1=1;cmp2=5;
    bp=biplot(coeff(:,[cmp1 cmp2]),'VarLabels',data_name,'LineWidth',3,'MarkerSize',30);
    sg_mod_biplot(bp,explained,cmp1,cmp2,data_colorid)

    pause(0.15)
    print(fig_filename, '-dpng', '-r300')
    pause(0.1)

    h(2).fig = figure(fig_num+1);
    set(h(2).fig, 'Position', [fig_size(1) fig_size(2) fig_size(3) 0.45*fig_size(4)]);

    subplot(1,2,1)
    cmp1=2;cmp2=3;
    bp=biplot(coeff(:,[cmp1 cmp2]),'VarLabels',data_name,'LineWidth',3,'MarkerSize',30);
    title('PCA variable biplot projection')
    sg_mod_biplot(bp,explained,cmp1,cmp2,data_colorid)

    subplot(1,2,2)
    plot(explained,'-','LineWidth',4,'Marker','.','MarkerSize',60,'Color',[0 0.749 1])
    axis([1 size(data,2) 0 explained(1)+2])
    grid on
    xlabel('Component number')
    ylabel('Explained variability [%]')
    title('Variability explained per each component')
    set(gca,'FontSize',13,'LineWidth',2)

    pause(0.15)
    print([fig_filename '_supplement'], '-dpng', '-r300')
    pause(0.1)
end

function sg_mod_biplot(bp,explained,cmp1,cmp2,data_colorid)
    alpha=0.65;
    color_table = [
        0 1 0 alpha
        1 0 1 alpha
        1 0 0 alpha
        0 0.749 1 alpha
        1 1 0 alpha
        ];
    color_pos = 1;
    for ind = 1:(size(bp,1)-1)
        if bp(ind).Color(3) == 1
            bp(ind).Color = color_table(data_colorid(color_pos),:);
            bp(ind).LineWidth = 4;
            bp(ind).MarkerSize = 40;
            color_pos = color_pos + 1;
            if color_pos > size(explained,1)
                color_pos = 1;
            end
        else     
            bp(ind).FontSize = 8;
            bp(ind).FontWeight = 'bold';
            if bp(ind).Position(1) < 0
                bp(ind).HorizontalAlignment = 'right';
            end
            if bp(ind).Position(2) >= 0 && bp(ind).Position(2) < 0.03
                bp(ind).Position(2) = bp(ind).Position(2)+0.015;
            elseif bp(ind).Position(2) <= 0 && bp(ind).Position(2) > -0.03
                bp(ind).Position(2) = bp(ind).Position(2)-0.015;
            end
        end
    end
    bp(end).LineWidth=3;
    xlabel(['Component ' num2str(cmp1) ' [variability: ' num2str(round(explained(cmp1,1)*100)/100,'%.2f') '%]'])
    ylabel(['Component ' num2str(cmp2) ' [variability: ' num2str(round(explained(cmp2,1)*100)/100,'%.2f') '%]'])
    set(gca,'FontSize',13,'LineWidth',2)
    set(gca,'XTick',-1:0.1:1,'XTickLabel',num2str([-1:0.1:1]'))
    set(gca,'YTick',-1:0.1:1,'YTickLabel',num2str([-1:0.1:1]'))
end