<script>
	import { Locale } from '@store/stores'
	import { timeAgo } from '@utils/timeAgo'
	import {
		Clock,
		MapPin,
		Info,
		Route,
		User,
		Shield,
		Car,
		Contact,
		Users,
		Phone,
		Circle,
	} from 'lucide-svelte'

	let { dispatch, fields = [], respondKey = null } = $props()

	const fieldIcons = {
		Street: MapPin,
		Information: Info,
		Distance: Route,
		Person: User,
		Vehicle: Car,
		Plate: Contact,
		Weapon: Shield,
		Units: Users,
		Call: Phone,
		Time: Clock,
		Location: MapPin,
	}

	function getFieldIcon(label) {
		return fieldIcons[label] || Circle
	}

	function t(key, fallback) {
		return $Locale?.[key] ?? fallback
	}

	function getFieldLabel(label) {
		const labels = {
			Street: t('ui_street', 'Street'),
			Information: t('ui_information', 'Information'),
			Distance: t('ui_distance', 'Distance'),
			Person: t('ui_person', 'Person'),
			Gender: t('ui_gender', 'Gender'),
			Vehicle: t('ui_vehicle', 'Vehicle'),
			Plate: t('ui_plate', 'Plate'),
			Weapon: t('ui_weapon', 'Weapon'),
			Units: t('ui_units', 'Units'),
			Call: t('ui_call', 'Call'),
			Time: t('ui_time', 'Time'),
			Location: t('ui_location', 'Location'),
		}

		return labels[label] ?? label
	}

	function shouldRender(value) {
		if (value == null) return false
		if (typeof value === 'string') {
			const v = value.trim().toLowerCase()
			if (!v || v === 'unknown') return false
		}
		return true
	}

	function priorityBar(priority) {
		return priority == 1 ? 'bg-red-400' : 'bg-cyan-400'
	}

	function priorityGlow(priority) {
		return priority == 1
			? 'shadow-[0_0_16px_rgba(248,113,113,0.28)]'
			: 'shadow-[0_0_16px_rgba(34,211,238,0.24)]'
	}

	function codeBadgeClass(priority) {
		return priority == 1
			? 'siren-code-badge shrink-0 rounded-[3px] border px-1.5 py-px text-[10px] font-bold leading-4 tracking-wide text-white tabular-nums'
			: 'shrink-0 rounded-[3px] border border-blue-300/30 bg-blue-500/12 px-1.5 py-px text-[10px] font-bold leading-4 tracking-wide text-blue-100 tabular-nums'
	}

	const visibleFields = $derived(
		fields.filter((f) => f.label !== 'Street' && shouldRender(f.value)),
	)

	const clockTime = $derived(
		new Date(dispatch.time).toLocaleTimeString([], {
			hour: '2-digit',
			minute: '2-digit',
		}),
	)
</script>

<div
	class="relative overflow-hidden rounded-[4px] border border-black/35 bg-zinc-950/65 text-white shadow-[inset_0_1px_0_rgba(255,255,255,0.08),inset_0_0_0_1px_rgba(255,255,255,0.03),0_10px_28px_rgba(0,0,0,0.4)] backdrop-blur-md"
>
	<div
		class="absolute inset-y-0 left-0 w-1 {priorityBar(
			dispatch.priority,
		)} {priorityGlow(dispatch.priority)}"
	></div>

	<div class="px-3 pb-2.5 pl-4 pt-2.5">
		<div
			class="flex min-w-0 items-center gap-2 border-b border-white/[0.06] pb-1.5"
		>
			<span
				class="shrink-0 rounded-[3px] border border-blue-300/30 bg-blue-500/12 px-1.5 py-px text-[10px] font-bold leading-4 tracking-wide text-blue-100"
			>
				#{dispatch.id}
			</span>
			{#if dispatch.code}
				<span class={codeBadgeClass(dispatch.priority)}>
					{dispatch.code}
				</span>
			{/if}
			{#if dispatch.icon}
				<i
					class="{dispatch.icon} dispatch-fa-icon shrink-0 text-[11px] {dispatch.priority == 1
						? 'priority-one-fa-icon text-red-500'
						: 'text-zinc-300'}"
					aria-hidden="true"
				></i>
			{/if}
			<p
				class="line-clamp-1 min-w-0 flex-1 text-sm font-semibold uppercase leading-5 tracking-wide text-zinc-50"
			>
				{dispatch.message}
			</p>
			<span
				class="shrink-0 text-[10px] font-medium leading-4 text-zinc-500 tabular-nums"
			>
				{timeAgo(dispatch.time)}
			</span>
		</div>

		<div class="mt-2 flex min-w-0 items-center gap-1.5">
			<MapPin class="h-3.5 w-3.5 shrink-0 text-cyan-300" />
			<span
				class="line-clamp-1 min-w-0 flex-1 text-xs font-semibold text-zinc-200"
			>
				{dispatch.street || dispatch.location || t('ui_unknown_location', 'Unknown location')}
			</span>
			<span
				class="shrink-0 text-[10px] font-medium text-zinc-600 tabular-nums"
			>
				{clockTime}
			</span>
		</div>

		{#if visibleFields.length > 0}
			<div class="mt-2 grid gap-1">
				{#each visibleFields as field (field.label)}
					{@const Icon = getFieldIcon(field.label)}
					<div
						class="flex min-w-0 items-center gap-1.5 rounded-[4px] border border-white/[0.05] bg-white/[0.025] px-2 py-1 text-[11px] leading-4"
					>
						<Icon class="h-3 w-3 shrink-0 text-zinc-500" />
						<span class="shrink-0 font-semibold text-zinc-500">
							{getFieldLabel(field.label)}:
						</span>
						<span class="line-clamp-1 min-w-0 flex-1 text-zinc-300">
							{field.value}
						</span>
					</div>
				{/each}
			</div>
		{/if}

		{#if respondKey}
			<div class="mt-2.5 flex justify-end">
				<span
					class="rounded-[3px] border border-blue-300/35 bg-blue-500/18 px-2 py-0.5 text-[10px] font-bold uppercase leading-4 tracking-wide text-blue-100"
				>
					[{respondKey}] {t('ui_respond', 'Respond')}
				</span>
			</div>
		{/if}
	</div>
</div>

<style>
	.siren-code-badge {
		border-color: rgb(248 113 113 / 0.45);
		background:
			linear-gradient(90deg, rgb(239 68 68 / 0.9) 0 48%, rgb(37 99 235 / 0.9) 52% 100%);
		box-shadow:
			0 0 10px rgb(239 68 68 / 0.45),
			0 0 14px rgb(59 130 246 / 0.35);
		animation: siren-code-flash 900ms steps(2, end) infinite;
	}

	.dispatch-fa-icon {
		width: 0.875rem;
		text-align: center;
		filter: drop-shadow(0 0 4px rgb(255 255 255 / 0.16));
	}

	.priority-one-fa-icon {
		color: rgb(239 68 68) !important;
		filter: drop-shadow(0 0 7px rgb(239 68 68 / 0.75));
	}

	@keyframes siren-code-flash {
		0%,
		100% {
			border-color: rgb(248 113 113 / 0.55);
			background:
				linear-gradient(90deg, rgb(239 68 68 / 0.95) 0 48%, rgb(37 99 235 / 0.65) 52% 100%);
			box-shadow:
				0 0 10px rgb(239 68 68 / 0.55),
				0 0 12px rgb(59 130 246 / 0.25);
		}

		50% {
			border-color: rgb(96 165 250 / 0.55);
			background:
				linear-gradient(90deg, rgb(239 68 68 / 0.65) 0 48%, rgb(37 99 235 / 0.95) 52% 100%);
			box-shadow:
				0 0 10px rgb(59 130 246 / 0.55),
				0 0 12px rgb(239 68 68 / 0.25);
		}
	}
</style>
