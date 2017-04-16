function drawEllipse(ax, center)
t=-pi:0.05:pi;
x=center(1)+ax(1)*cos(t);
y=center(2)+ax(2)*sin(t);
plot(x,y,'r')

end