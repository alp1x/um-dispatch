let _resourceName: string = '';

function getResourceName(): string {
    if (!_resourceName) {
        _resourceName = (window as any).GetParentResourceName?.() ?? 'nui-frame-app';
    }
    return _resourceName;
}

export async function SendNUI<T = any>(eventName: string, data?: any): Promise<T | null> {
    try {
        const resp = await fetch(`https://${getResourceName()}/${eventName}`, {
            method: 'post',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data),
        });

        return await resp.json();
    } catch (e) {
        console.error(`[SendNUI] ${eventName} failed:`, e);
        return null;
    }
}
