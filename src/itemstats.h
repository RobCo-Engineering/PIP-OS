#include <QObject>
#include <QQmlEngine>

namespace PipOS {
class ItemStats : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariant data READ data WRITE setData NOTIFY dataChanged FINAL)

public:
    explicit ItemStats(QObject *parent = nullptr);

    QVariant data() const;
    void setData(const QVariant &newData);

signals:
    void dataChanged();

private:
    QVariant m_data;
};
} // namespace PipOS
