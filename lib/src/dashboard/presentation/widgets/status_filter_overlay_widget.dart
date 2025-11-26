import '../../../../pkg.dart';

class StatusFilterPopup extends StatelessWidget {
  final Function(DeviceStatus?) onStatusSelected;
  final DeviceStatus? selectedStatus;

  const StatusFilterPopup({super.key, required this.onStatusSelected, this.selectedStatus});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          width: widthQuery(context) * 0.65,
          decoration: BoxDecoration(color: ColorValues.neutral400, borderRadius: BorderRadius.circular(30)),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _buildFilterChip(context, 'ALL', null),
              _buildFilterChip(context, getDeviceStatusText(DeviceStatus.active), DeviceStatus.active),
              _buildFilterChip(context, getDeviceStatusText(DeviceStatus.idle), DeviceStatus.idle),
              _buildFilterChip(context, getDeviceStatusText(DeviceStatus.offline), DeviceStatus.offline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, DeviceStatus? status) {
    final bool isSelected = selectedStatus == status;

    final Color backgroundColor = isSelected
        ? (status == DeviceStatus.active
              ? ColorValues.success700
              : status == DeviceStatus.idle
              ? ColorValues.blueProgress
              : status == DeviceStatus.offline
              ? ColorValues.danger700
              : ColorValues.blackColor)
        : ColorValues.whiteColor;

    final Color textColor = isSelected ? ColorValues.whiteColor : ColorValues.blackColor;

    return GestureDetector(
      onTap: () {
        onStatusSelected(status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: status == DeviceStatus.active
                      ? ColorValues.success200
                      : status == DeviceStatus.idle
                      ? ColorValues.blueProgress.withValues(alpha: 0.2)
                      : status == DeviceStatus.offline
                      ? ColorValues.danger700.withValues(alpha: 0.2)
                      : ColorValues.blackColor.withValues(alpha: 0.2),
                ),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
