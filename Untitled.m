[LE, Camber, TE, Camber2, Curve1, Curve2, Curve3, Curve4, CP, Bladeprof] = BladeManual(20, 60, 20, 0.15, 0.050, 90, 90, 70, 85, 0.015, 1.0, 0.6, 0.3, 40, 30);
plot(LE(1,:),LE(2,:))
hold on
plot(Camber(1,:), Camber(2,:))
hold on
plot(TE(1,:),TE(2,:))
hold on
plot(CP(1,1), CP(1,2),'*', CP(2,1), CP(2,2),'*', CP(3,1), CP(3,2), '*', CP(4,1), CP(4,2),'*', CP(5,1), CP(5,2),'*', CP(6,1), CP(6,2),'*')
hold on
plot(Curve1(1,:), Curve1(2,:))
hold on
plot(Curve2(1,:), Curve2(2,:))
hold on
plot(Curve3(1,:), Curve3(2,:))
hold on
plot(Curve4(1,:), Curve4(2,:))
hold off
axis equal
