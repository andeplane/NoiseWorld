#ifndef CYLINDERDATA_H
#define CYLINDERDATA_H

#include <QObject>
#include <Qt3DRender/QBuffer>
#include <Qt3DCore/QNode>
#include <QVector3D>

struct CylinderVBOData
{
    QVector3D vertex1;
    QVector3D vertex2;
    float radius1;
    float radius2;
};

// TODO rename to CylinderBuffer
class CylinderData : public Qt3DCore::QNode
{
    Q_OBJECT
    Q_PROPERTY(Qt3DRender::QBuffer* buffer READ buffer CONSTANT)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    explicit CylinderData(QNode *parent = 0);

    Qt3DRender::QBuffer* buffer();
    void setData(QVector<CylinderVBOData> data);
    int count() const;

signals:

    void countChanged(int count);

public slots:

private:
    QScopedPointer<Qt3DRender::QBuffer> m_buffer;
    int m_count = 0;
};

#endif // CYLINDERDATA_H
