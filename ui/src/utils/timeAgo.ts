const MONTH_NAMES = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

function getFormattedDate(date: Date, prefomattedDate: string | false = false, hideYear = false) {
  const day = date.getDate();
  const month = MONTH_NAMES[date.getMonth()];
  const year = date.getFullYear();
  const hours = date.getHours();
  const minutes = String(date.getMinutes()).padStart(2, '0');

  if (prefomattedDate) {
      return `${prefomattedDate} at ${hours}:${minutes}`;
  }

  if (hideYear) {
      return `${day}. ${month} at ${hours}:${minutes}`;
  }

      return `${day}. ${month} ${year}. at ${hours}:${minutes}`;
  }


export function timeAgo(dateParam: Date | string | number | null | undefined) {
  if (!dateParam) {
  return 'Unknown';  
  }

  let date: Date;
  try {
  date =  typeof dateParam === 'object' ? dateParam : new Date(dateParam);    
  } catch (e) {
  return 'Invalid date';
  }

  if (Number.isNaN(date.getTime())) {
  return 'Invalid date';  
  }
  const DAY_IN_MS = 86400000;
  const today = new Date();
  const yesterday = new Date(today.getTime() - DAY_IN_MS);
  const seconds = Math.round((today.getTime() - date.getTime()) / 1000);
  const minutes = Math.round(seconds / 60);
  const isToday = today.toDateString() === date.toDateString();
  const isYesterday = yesterday.toDateString() === date.toDateString();
  const isThisYear = today.getFullYear() === date.getFullYear();

  if (seconds < 5) {
      return 'Just Now';
  } else if (seconds < 60) {
      return `${seconds} Seconds ago`;
  } else if (seconds < 90) {
      return 'A minute ago';
  } else if (minutes < 60) {
      return `${minutes} Minutes ago`;
  } else if (isToday) {
      return getFormattedDate(date, 'Today');
  } else if (isYesterday) {
      return getFormattedDate(date, 'Yesterday');
  } else if (isThisYear) {
      return getFormattedDate(date, false, true);
  }

  return getFormattedDate(date);
}